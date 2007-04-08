Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbXDHEHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbXDHEHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 00:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXDHEHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 00:07:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10345 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXDHEH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 00:07:27 -0400
Date: Sat, 7 Apr 2007 21:09:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] partitions: Rewrite check_partition to remove
 necessity of check_part
Message-Id: <20070407210936.4ceaa9fd.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.83.0704072340550.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
	<alpine.DEB.0.83.0704072340550.27057@sigma.j-a-k-j.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 23:42:00 -0400 (EDT) John Anthony Kazos Jr. wrote:

> From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> Removes the entire check_part array and uses the presence of new stub 
> functions in header files in fs/partitions to call them directly in a list 
> and let the compiler optimize away any that aren't compiled in. Also fixes 
> a bug where " unable to read partition table" would never be printed.
> 
> Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
> 
> ---
> 
> I did this because it seems to be much easier to understand. And even 
> though the memory used by the array was only sizeof(void*)*n+1 for the 
> number of partitions configured to be included, that's still unnecessary 
> usage.
> 
> This code also has two warn_unused_result problems, but I don't feel up to 
> the task of fixing those yet.
> 
> Within the old loop, if res < 0, res = 0, and immediately after the loop, 
> the function returns if res > 0. Therefore, it must be that res == 0 after 
> the loop. if (!err) is true only if err == 0 so again, res == 0, so if 
> (!res) is true, and the else condition can never be reached. I 
> re-interpreted the intent to be "log a message if the partition format is 
> unrecognized, and log a message if the partition cannot be read but only 
> if the warning is requested". Judging by the "This is ugly" comment, the 
> warning is not intended to account for actual I/O errors when reading the 
> partition-table block, but rather to detect when the partitions are 
> checked for a device with a medium that has been removed.
> 
> --- linux-2.6.20.6-orig/fs/partitions/check.c	2007-04-06 16:02:48.000000000 -0400
> +++ linux-2.6.20.6-mod/fs/partitions/check.c	2007-04-07 21:50:22.000000000 -0400
> @@ -41,73 +41,6 @@ extern void md_autodetect_dev(dev_t dev)
>  
>  int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/

[snip]

>  /*
>   * disk_name() is used by partition check code and the genhd driver.
>   * It formats the devicename of the indicated disk into
> @@ -149,11 +82,125 @@ const char *__bdevname(dev_t dev, char *
>  
>  EXPORT_SYMBOL(__bdevname);
>  
> +static int
> +check_succeeded(int res, struct parsed_partitions *state, int *err)
> +{
> +	if (res < 0) {
> +		/* We have hit an I/O error which we don't report now.
> +		 * But record it, and let the others do their job.
> +		 */
> +		*err = res;
> +		res = 0;
> +	}
> +
> +	if (!res) {
> +		memset(state->parts, 0, sizeof(state->parts));
> +	}

No braces on single-statement blocks.  (many of these below also)

> +
> +	return res;
> +}
> +
> +static struct parsed_partitions *
> +do_check_list(struct parsed_partitions *state, struct block_device *bdev)
> +{
> +	int err;
> +
> +	err = 0;
> +
> +        /*

Use tab to indent (above), not (only) spaces.

> +	 * Probe partition formats with tables at disk address 0
> +	 * that also have an ADFS boot block at 0xdc0.
> +	 */
> +	if (check_succeeded(adfspart_check_ICS(state, bdev), state, &err)) {
> +		return state;
> +	}
> +	if (check_succeeded(adfspart_check_POWERTEC(state, bdev), state, &err)) {
> +		return state;
> +	}
> +	if (check_succeeded(adfspart_check_EESOX(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +        /*

tab above

> +	 * Now move on to formats that only have partition info at
> +	 * disk address 0xdc0.  Since these may also have stale
> +	 * PC/BIOS partition tables, they need to come before
> +	 * the msdos entry.
> +	 */
> +	if (check_succeeded(adfspart_check_CUMANA(state, bdev), state, &err)) {
> +		return state;
> +	}
> +	if (check_succeeded(adfspart_check_ADFS(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	/* this must come before msdos */
> +	if (check_succeeded(efi_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(sgi_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	/* this must come before msdos */
> +	if (check_succeeded(ldm_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(msdos_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(osf_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(sun_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(amiga_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(atari_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(mac_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(ultrix_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(ibm_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	if (check_succeeded(karma_partition(state, bdev), state, &err)) {
> +		return state;
> +	}
> +
> +	kfree(state);
> +
> +	if (err) {
> +		if (warn_no_part) {
> +			printk(" unable to read partition table\n");
> +		}
> +	} else {
> +		printk(" unknown partition table\n");
> +	}
> +
> +	return ERR_PTR(err);
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
