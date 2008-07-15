Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYGOBIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYGOBIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYGOBIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:08:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:36420 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYGOBIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rv4StIW8r2bxmLRKR46XrA3ZfozMOYuVRrCffSUBHcoFCV/bmDxpnfi6S1zH9LC8Js
         fXasXGX9QnN5kp0a7La2Wz+KVhuHqCsnHeqId0xAkc2J8CPEHSZjWIW0nfXVHIyh6pU2
         xB35AyZNjgWzZHsJjVIM9fgo7IhDRBFrl5lcc=
Message-ID: <86802c440807141808u25b1ea95w852d08111548ee31@mail.gmail.com>
Date: Mon, 14 Jul 2008 18:08:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <1216083024.27455.123.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
	 <1216081404.27455.97.camel@shinybook.infradead.org>
	 <86802c440807141731m5286f640jfeaff1a73b923e7@mail.gmail.com>
	 <1216083024.27455.123.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 5:50 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2008-07-14 at 17:31 -0700, Yinghai Lu wrote:
>> make[1]: *** No rule to make target
>> `include/config/builtin/firmware/dir.h', needed by
>> `firmware/ql2100_fw.bin.gen.S'.  Stop.
>> make: *** [firmware] Error 2
>
> Oh, pants. Sorry, I renamed the CONFIG_BUILTIN_FIRMWARE option to
> CONFIG_EXTRA_FIRMWARE some time back, but all my own test builds had the
> include/config/builtin/firmware/dir.h file still lying around so I
> didn't notice that I'd forgotten to change that manual dependency. And
> evidently nobody using linux-next actually tried to include arbitrary
> _other_ firmware into their tree. This patch should fix it...
>
> (Why _do_ we have stray files left in include/config/ when config
> options go away, btw? Shouldn't they get deleted?)
>
> ----
> Subject: firmware: Correct dependency on CONFIG_EXTRA_FIRMWARE_DIR
>
> When CONFIG_EXTRA_FIRMWARE_DIR gets changed, the filename in the .S file
> (which uses .incbin to include the binary) needs to change. When we
> renamed the BUILTIN_FIRMWARE_DIR option to EXTRA_FIRMWARE_DIR, we forgot
> to update the manual dependency in firmware/Makefile, so it was
> depending on a non-existent file in include/config/
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
> diff --git a/firmware/Makefile b/firmware/Makefile
> index 5a1e61c..ec4f0cc 100644
> --- a/firmware/Makefile
> +++ b/firmware/Makefile
> @@ -146,7 +146,7 @@ $(patsubst %,$(obj)/%.gen.S, $(fw-shipped-y)): %: $(wordsize_deps) \
>                | $(objtree)/$$(dir %)
>        $(call cmd,fwbin,$(patsubst %.gen.S,%,$@))
>  $(patsubst %,$(obj)/%.gen.S, $(fw-external-y)): %: $(wordsize_deps) \
> -               include/config/builtin/firmware/dir.h | $(objtree)/$$(dir %)
> +               include/config/extra/firmware/dir.h | $(objtree)/$$(dir %)
>        $(call cmd,fwbin,$(fwabs)/$(patsubst $(obj)/%.gen.S,%,$@))
>
>  # The .o files depend on the binaries directly; the .S files don't.
>
>
> --
> dwmw2
>

thanks. it works

  MK_FW   firmware/ql2100_fw.bin.gen.S
  MK_FW   firmware/ql2300_fw.bin.gen.S
  MK_FW   firmware/ql2400_fw.bin.gen.S
  MK_FW   firmware/ql2200_fw.bin.gen.S
  MK_FW   firmware/ql2322_fw.bin.gen.S
  MK_FW   firmware/ql2500_fw.bin.gen.S
  AS      firmware/ql2100_fw.bin.gen.o
  AS      firmware/ql2300_fw.bin.gen.o
  AS      firmware/ql2400_fw.bin.gen.o
  AS      firmware/ql2200_fw.bin.gen.o
  AS      firmware/ql2322_fw.bin.gen.o
  AS      firmware/ql2500_fw.bin.gen.o
  LD      firmware/built-in.o


calling  qla2x00_module_init+0x0/0x131
QLogic Fibre Channel HBA Driver: 8.02.01-k4
ACPI: PCI Interrupt 0000:0c:02.0[A] -> GSI 57 (level, low) -> IRQ 57
qla2xxx 0000:0c:02.0: Found an ISP2312, irq 57, iobase 0xffffc2002d00c000
qla2xxx 0000:0c:02.0: Configuring PCI space...
qla2xxx 0000:0c:02.0: Configure NVRAM parameters...
qla2xxx 0000:0c:02.0: Verifying loaded RISC code...
firmware: using built-in firmware ql2300_fw.bin
qla2xxx 0000:0c:02.0: Allocated (412 KB) for firmware dump...

YH
