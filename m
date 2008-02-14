Return-Path: <linux-kernel-owner+w=401wt.eu-S1764463AbYBNLed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764463AbYBNLed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 06:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYBNLeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 06:34:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbYBNLeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 06:34:23 -0500
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
Content-Type: text/plain
Organization: Red Hat Ltd. Registered Address: Red Hat Ltd, Brian O'
	Donnell and Partners, 62 Merrion Square, Dublin 2, Ireland. Registered in
	the Companies Registration Office, Parnell House, 14 Parnell Square, Dublin
	1, Ireland, at No. 304873 Directors: Charlie Peters (USA), Michael
	Cunningham (USA), Matt Parson (USA), Brendan Lane
Date: Thu, 14 Feb 2008 11:34:04 +0000
Message-Id: <1202988844.26435.4.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 20:54 +0000, Ian Campbell wrote:
> This allows other boot loaders such as the Xen domain builder the
> opportunity to extract the ELF file.

	Right, Xen currently can't boot bzImage (it needs the ELF image) so you
still can't use the same kernel image on Xen as bare-metal.

> +Field name:	compressed_payload_offset
> +Type:		read
> +Offset/size:	0x248/4
> +Protocol:	2.08+
> +
> +  If non-zero then this field contains the offset from the end of the
> +  real-mode code to the compressed payload. The compression format
> +  should be determined using the standard magic number, currently only
> +  gzip is used.

	Should probably mention that the payload format is expected to be ELF.
 
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index f88458e..9695aff 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -94,6 +94,20 @@ $(obj)/vmlinux.bin: $(obj)/compressed/vmlinux FORCE
>  
>  SETUP_OBJS = $(addprefix $(obj)/,$(setup-y))
>  
> +sed-offsets := -e 's/^00*/0/' \
> +        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/\#define \2 0x\1/p'
> +
> +quiet_cmd_offsets = OFFSETS $@
> +      cmd_offsets = $(NM) $< | sed -n $(sed-offsets) > $@
> +
> +$(obj)/offsets.h: $(obj)/compressed/vmlinux FORCE
> +	$(call if_changed,offsets)
> +
> +targets += offsets.h
> +
> +AFLAGS_header.o += -I$(obj)
> +$(obj)/header.o: $(obj)/offsets.h

	How about this?

+sed-offsets := -e 's/^00*/0/' \
+        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/-D\2=0x\1 /p'
+
+$(obj)/header.o: AFLAGS_header.o += $(shell $(NM) $(obj)/compressed/vmlinux | sed -n $(sed-offsets))
+$(obj)/header.o: $(obj)/compressed/vmlinux FORCE

Cheers,
Mark.

