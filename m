Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZALXqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZALXqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZALXqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:46:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZALXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:46:11 -0500
Date: Mon, 12 Jan 2009 15:45:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wolfgang =?ISO-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Message-Id: <20090112154548.f29d57dd.akpm@linux-foundation.org>
In-Reply-To: <200901061517.01872.wolfgang.mues@auerswald.de>
References: <200901061517.01872.wolfgang.mues@auerswald.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009 15:17:01 +0100
Wolfgang M__es <wolfgang.mues@auerswald.de> wrote:

> David,
> 
> I have done some fixes and enhancements to the MMC SPI host controller driver.
> Practical results with SD/SDHC cards from different vendors are much better now. 
> The patch is for kernel 2.6.28.
> 
> (I do not read the linux kernel mailing list)

Please reissue this patch with a *full* changelog.  One which actually
describes these fixes and enhancements.  For fixes, fully decribe the
problem which was fixed.  For each enhancement, describe why that
enhancement is desirable/useful, if that is not obvious.

Before sending, please pass the patch through scripts/checkpatch.pl. 
This one adds various whitespace gremlins which you probably wouldn't
have sent, had you known they were there.

> 
> ============= snip ====================
> --- 2.6.28/drivers/mmc/host/mmc_spi.c	2008-11-24 10:26:06.000000000 +0100
> +++ new/drivers/mmc/host/mmc_spi.c	2009-01-06 14:52:59.000000000 +0100
> @@ -25,6 +25,7 @@
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  #include <linux/hrtimer.h>
> +#include <linux/sched.h>
>  #include <linux/delay.h>
>  #include <linux/bio.h>
>  #include <linux/dma-mapping.h>
> @@ -186,10 +187,10 @@
>  static int
>  mmc_spi_skip(struct mmc_spi_host *host, ktime_t timeout, unsigned n, u8 byte)
>  {
> -	u8		*cp = host->data->status;
> -
> -	timeout = ktime_add(timeout, ktime_get());
> -
> +	u8 *cp = host->data->status;
> +	unsigned long timeout_jiffies = (unsigned long) ((ktime_to_us(timeout) * HZ) / 1000000);

ktime_to_us() returns s64.  Dividing that by 1000000 introduces the
risk that the compiler will try to generate a 64-bit divide, which will
fail to link on x86_32.  Fixable by converting to unsigned long before
dividing, or via do_div().

layout: we don't *have* to do complex 100-column initialisations at the
definition site.  it's perfectly OK and often better to do:

	unsigned long timeout_jiffies;
	...
	timeout_jiffies = ...;

Please use USECS_PER_SEC for clarity, if appropriate.

> +	unsigned long starttime = jiffies;
> + 
>  	while (1) {
>  		int		status;
>  		unsigned	i;
> @@ -203,11 +204,13 @@
>  				return cp[i];
>  		}
>  
> -		/* REVISIT investigate msleep() to avoid busy-wait I/O
> -		 * in at least some cases.
> -		 */
> -		if (ktime_to_ns(ktime_sub(ktime_get(), timeout)) > 0)
> +		if ((jiffies - starttime) > timeout_jiffies)

time_after/time_before/etc would be preferred.

>  			break;
> +		/* If we need long timeouts, we may release the CPU. */
> +		/* We use jiffies here because we want to have a relation between
> +                   elapsed time and the blocking of the scheduler. */
> +		if ((jiffies - starttime) > 1)

time_after()...

> +			schedule();

does this actually do anything useful?  Presumably the
mmc_spi_readbytes() will block (unless SPI can to 10GB/sec), so I
wouldn't expect this schedule() to help anything.

If it _does_ help then we have bigger problems - if nothing esle is
runnable, we'll burn power like mad and a cpu_relax() might be needed.

>  	}
>  	return -ETIMEDOUT;
>  }
> @@ -280,7 +283,9 @@
>  		 * It'd probably be better to memcpy() the first chunk and
>  		 * avoid extra i/o calls...
>  		 */
> -		for (i = 2; i < 9; i++) {
> +		/* Note we check for more than 8 bytes, because in practice,
> +		   some SD cards are slow... */
> +		for (i = 2; i < 16; i++) {
>  			value = mmc_spi_readbytes(host, 1);
>  			if (value < 0)
>  				goto done;
> @@ -609,6 +614,15 @@
>  	struct spi_device	*spi = host->spi;
>  	int			status, i;
>  	struct scratch		*scratch = host->data;
> +	u32			pattern;
> +
> +	/* The MMC framework does a good job of computing timeouts
> +           according to the mmc/sd standard. However, we found that in
> +           SPI mode, there are many cards which need a longer timeout
> +           of 1s after receiving a long stream of write data. */
> +	struct timeval tv = ktime_to_timeval(timeout);

layout: Putting a big hole in the local definitions like this is
inviting someone else to later put some code statments *before* this
definition.  Then some other people will get compilation warnings. 
This would be better:

	u32			pattern;
	struct timeval tv;

	/* The MMC framework does a good job of computing timeouts
           according to the mmc/sd standard. However, we found that in
           SPI mode, there are many cards which need a longer timeout
           of 1s after receiving a long stream of write data. */
	tv = ktime_to_timeval(timeout);

Please format comments in the standard way:

	/*
	 * The MMC framework does a good job of computing timeouts
	 * according to the mmc/sd standard. However, we found that in
	 * SPI mode, there are many cards which need a longer timeout
	 * of 1s after receiving a long stream of write data.
	 */

and indent them with tabs, not spacespacespacespacespace.

> +	if (tv.tv_sec == 0)
> +		timeout = ktime_set(1,0);	
>  
>  	if (host->mmc->use_spi_crc)
>  		scratch->crc_val = cpu_to_be16(
> @@ -636,8 +650,23 @@
>  	 * doesn't necessarily tell whether the write operation succeeded;
>  	 * it just says if the transmission was ok and whether *earlier*
>  	 * writes succeeded; see the standard.
> -	 */
> -	switch (SPI_MMC_RESPONSE_CODE(scratch->status[0])) {
> +	 *
> +	 * In practice, there are (even modern SDHC-)Cards which need
> +	 * some bits to send the response, so we have to cope with this
> +	 * situation and check the response bit-by-bit. Arggh!!!
> +	 */
> +	pattern  = scratch->status[0] << 24;
> +	pattern |= scratch->status[1] << 16;
> +	pattern |= scratch->status[2] << 8;
> +	pattern |= scratch->status[3];
> +
> +	/* left-adjust to leading 0 bit */
> +	while (pattern & 0x80000000)
> +		pattern <<= 1;
> +	/* right-adjust for pattern matching. Code is in bit 4..0 now. */
> +	pattern >>= 27;

hm, wow, that looks like sad hardware.

> +	switch (pattern) {
>  	case SPI_RESPONSE_ACCEPTED:
>  		status = 0;
>  		break;
> @@ -668,9 +697,9 @@
>  	/* Return when not busy.  If we didn't collect that status yet,
>  	 * we'll need some more I/O.
>  	 */
> -	for (i = 1; i < sizeof(scratch->status); i++) {
> -		if (scratch->status[i] != 0)
> -			return 0;
> +	for (i = 4; i < sizeof(scratch->status); i++) {
> +		if (scratch->status[i] & 0x01)
> + 			return 0;
>  	}
>  	return mmc_spi_wait_unbusy(host, timeout);
>  }
> @@ -743,7 +772,11 @@
>  		return -EIO;
>  	}
>  
> -	if (host->mmc->use_spi_crc) {
> +	/* Omitt the CRC check for CID and CSD reads. There are some SDHC
> +	   cards which don't supply a valid CRC after CID reads.
> +	   Note that the CID has it's own CRC7 value inside the data block.
> +	*/

spelling: "Omit".

layout.

> +	if (host->mmc->use_spi_crc && (t->len == MMC_SPI_BLOCKSIZE)) {
>  		u16 crc = crc_itu_t(0, t->rx_buf, t->len);
>  
>  		be16_to_cpus(&scratch->crc_val);
> @@ -1206,8 +1239,15 @@
>  	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
>  	 * should be legit.  We'll use mode 0 since it seems to be a
>  	 * bit less troublesome on some hardware ... unclear why.
> -	 */
> -	spi->mode = SPI_MODE_0;
> +	 *
> +	 * If the platform_data specifies mode 3, trust the platform_data
> +	 * and use this one. This allows for platforms which do not support
> +	 * mode 0.
> +	 */
> +	if (spi->mode != SPI_MODE_3)
> +		/* set our default */
> +		spi->mode = SPI_MODE_0;
> +
>  	spi->bits_per_word = 8;
>  
>  	status = spi_setup(spi);

