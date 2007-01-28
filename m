Return-Path: <linux-kernel-owner+w=401wt.eu-S932935AbXA1Wo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935AbXA1Wo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932937AbXA1Wo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:44:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:45349 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbXA1Wo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=pv2Lsspe7wfitFI1uki82l60cfaHuhYI7qmm/GqRC9Yu4An9VWhcQW0jUnNJzwaYvxydDoM3+4csW7JMBUMkio8QON+8eUv+wst//Thmf3okZZztVI1F2TZNXSNHMiO2D0kCjH8bpDApjB8fM/80LgEs4CoMzkoei9YMWYpqiME=
Message-ID: <82e4877d0701281444h333c581fr66d60cca9d03749d@mail.gmail.com>
Date: Sun, 28 Jan 2007 17:44:26 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: thunder7@xs4all.nl
Subject: Re: 2.6.20-rc6-mm1: linker error with arch_setup_additional_pages
Cc: "akpm@osdl.org" <akpm@osdl.org>, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <82e4877d0701280834n75d3d0d3ja7a35d5ea0e7fa4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_66520_25763628.1170024266176"
References: <82e4877d0701280834n75d3d0d3ja7a35d5ea0e7fa4f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_66520_25763628.1170024266176
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 1/28/07, Parag Warudkar <parag.warudkar@gmail.com> wrote:
> >CONFIG_BINFMT_ELF=y
> ># CONFIG_BINFMT_MISC is not set
> ># CONFIG_IA32_EMULATION is not set
>
> Hm Ok. That's explainable. You don't have CONFIG_IA32_EMULATION set
> and arch_setup_additional pages is only defined/exported in
> syscall32.c which won't be built in your case. (It should go away if
> you set CONFIG_IA32_EMULATION).
>

I think the easy and correct fix for this situation is defining
CONFIG_ARCH_HAS_SETUP_ADDITIONAL_PAGES on x86_64 only if
IA32_EMULATION is defined. (Because x86_64 proper doesn't seem to
require arch_setup_additional_pages() only IA32 emulation requires
it.)

The patch below should fix it. (Please use attachment - less chance of
whitespace issues. Sorry no control over mail client atm)

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6.20-rc6-mm1/arch/x86_64/Kconfig.orig	2007-01-28
17:32:09.000000000 -0500
+++ linux-2.6.20-rc6-mm1/arch/x86_64/Kconfig	2007-01-28 17:32:48.000000000 -0500
@@ -405,7 +405,7 @@
 config ARCH_HAS_SETUP_ADDITIONAL_PAGES
 	bool
 	default y
-	depends on X86_64
+	depends on X86_64 && IA32_EMULATION

 config OUT_OF_LINE_PFN_TO_PAGE
 	def_bool y

------=_Part_66520_25763628.1170024266176
Content-Type: text/x-patch; 
	name=x86_64-Kconfig-fix-setup_additional_pages.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_exi25l4s
Content-Disposition: attachment; filename="x86_64-Kconfig-fix-setup_additional_pages.patch"

LS0tIGxpbnV4LTIuNi4yMC1yYzYtbW0xL2FyY2gveDg2XzY0L0tjb25maWcub3JpZwkyMDA3LTAx
LTI4IDE3OjMyOjA5LjAwMDAwMDAwMCAtMDUwMAorKysgbGludXgtMi42LjIwLXJjNi1tbTEvYXJj
aC94ODZfNjQvS2NvbmZpZwkyMDA3LTAxLTI4IDE3OjMyOjQ4LjAwMDAwMDAwMCAtMDUwMApAQCAt
NDA1LDcgKzQwNSw3IEBACiBjb25maWcgQVJDSF9IQVNfU0VUVVBfQURESVRJT05BTF9QQUdFUwog
CWJvb2wKIAlkZWZhdWx0IHkKLQlkZXBlbmRzIG9uIFg4Nl82NAorCWRlcGVuZHMgb24gWDg2XzY0
ICYmIElBMzJfRU1VTEFUSU9OCiAKIGNvbmZpZyBPVVRfT0ZfTElORV9QRk5fVE9fUEFHRQogCWRl
Zl9ib29sIHkK
------=_Part_66520_25763628.1170024266176--
