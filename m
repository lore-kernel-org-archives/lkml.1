Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYG1Qlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYG1Qlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYG1Ql2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:41:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:46467 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372AbYG1Ql1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:41:27 -0400
Subject: Re: [PATCH 06/12] ipwireless: Remove endian-dependent bitfields
From: Petr Tesarik <ptesarik@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz
In-Reply-To: <20080728145300.13378.13591.stgit@ds.suse.cz>
References: <20080728145124.13378.39300.stgit@ds.suse.cz>
	 <20080728145300.13378.13591.stgit@ds.suse.cz>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Mon, 28 Jul 2008 18:41:26 +0200
Message-Id: <1217263286.27380.40.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 16:53 +0200, David Sterba wrote:
> ipwireless: Remove endian-dependent bitfields
> 
> Remove endian-dependent bitfields and use bitmasks to transform
> packet header bitfields from/to machine order.
> 
> Signed-off-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
>  drivers/char/pcmcia/ipwireless/hardware.c |   51 ++++++++++++++++++++++-------
>  1 files changed, 38 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
> index 7428734..08423ba 100644
> --- a/drivers/char/pcmcia/ipwireless/hardware.c
> +++ b/drivers/char/pcmcia/ipwireless/hardware.c
> @@ -132,29 +132,17 @@ enum {
>  #define NL_FOLLOWING_PACKET_HEADER_SIZE    1
>  
>  struct nl_first_packet_header {
> -#if defined(__BIG_ENDIAN_BITFIELD)
> -	unsigned char packet_rank:2;
> -	unsigned char address:3;
> -	unsigned char protocol:3;
> -#else
>  	unsigned char protocol:3;
>  	unsigned char address:3;
>  	unsigned char packet_rank:2;
> -#endif
>  	unsigned char length_lsb;
>  	unsigned char length_msb;
>  };

What's the point of keeping the bitfields? If it has no relation to
hardware, convert it to bytes. If it has, rename it to e.g. flags and
provide nice inline functions to access the relevant bits.

But this looks messy, because there is always a point in time where the
layout of the struct does not match actual memory conents. :(

Petr

>  
>  struct nl_packet_header {
> -#if defined(__BIG_ENDIAN_BITFIELD)
> -	unsigned char packet_rank:2;
> -	unsigned char address:3;
> -	unsigned char protocol:3;
> -#else
>  	unsigned char protocol:3;
>  	unsigned char address:3;
>  	unsigned char packet_rank:2;
> -#endif
>  };
>  
>  /* Value of 'packet_rank' above */
> @@ -382,7 +370,37 @@ static void dump_data_bytes(const char *type, const unsigned char *data,
>  			length < DUMP_MAX_BYTES ? length : DUMP_MAX_BYTES);
>  }
>  
> -static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
> +static void swap_packet_bitfield_to_le(unsigned char *data)
> +{
> +#ifdef __BIG_ENDIAN_BITFIELD
> +	unsigned char tmp = *data, ret = 0;
> +
> +	/*
> +	 * transform bits from aa.bbb.ccc to ccc.bbb.aa
> +	 */
> +	ret |= tmp & 0xc0 >> 6;
> +	ret |= tmp & 0x38 >> 1;
> +	ret |= tmp & 0x07 << 5;
> +	*data = ret & 0xff;
> +#endif
> +}
> +
> +static void swap_packet_bitfield_from_le(unsigned char *data)
> +{
> +#ifdef __BIG_ENDIAN_BITFIELD
> +	unsigned char tmp = *data, ret = 0;
> +
> +	/*
> +	 * transform bits from ccc.bbb.aa to aa.bbb.ccc
> +	 */
> +	ret |= tmp & 0xe0 >> 5;
> +	ret |= tmp & 0x1c << 1;
> +	ret |= tmp & 0x03 << 6;
> +	*data = ret & 0xff;
> +#endif
> +}
> +
> +static int do_send_fragment(struct ipw_hardware *hw, unsigned char *data,
>  			    unsigned length)
>  {
>  	unsigned i;
> @@ -402,6 +420,7 @@ static int do_send_fragment(struct ipw_hardware *hw, const unsigned char *data,
>  	spin_lock_irqsave(&hw->lock, flags);
>  
>  	hw->tx_ready = 0;
> +	swap_packet_bitfield_to_le(data);
>  
>  	if (hw->hw_version == HW_VERSION_1) {
>  		outw((unsigned short) length, hw->base_port + IODWR);
> @@ -458,6 +477,10 @@ static int do_send_packet(struct ipw_hardware *hw, struct ipw_tx_packet *packet)
>  	if (data_left < fragment_data_len)
>  		fragment_data_len = data_left;
>  
> +	/*
> +	 * hdr_first is now in machine bitfield order, which will be swapped
> +	 * to le just before it goes to hw
> +	 */
>  	pkt.hdr_first.protocol = packet->protocol;
>  	pkt.hdr_first.address = packet->dest_addr;
>  	pkt.hdr_first.packet_rank = 0;
> @@ -883,6 +906,8 @@ static void do_receive_packet(struct ipw_hardware *hw)
>  
>  	acknowledge_data_read(hw);
>  
> +	swap_packet_bitfield_from_le(pkt);
> +
>  	if (ipwireless_debug)
>  		dump_data_bytes("recv", pkt, len);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

