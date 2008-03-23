Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYCWJlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYCWJlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYCWJlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 05:41:24 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:21521 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYCWJlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 05:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=WXxc/lnU9T8rwTJ2oO4/1TkWv8mWmRHrsoUxqK8cbfzVHuy8N+FpmPz92/33Z+7W7rzQrJd4AALdAokb6GSOeLtm3DDWUxgx5jBPSFQeKx0ceUaO9sZT+ULihvAx80m8pj2PuzYULXGxmDxXEh4A/MB3TC3ak29Cric3mvWfgto=
From: "Roy Lee" <roylee17@gmail.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: <linux-kernel@vger.kernel.org>
References: <000101c889f3$ef5989e0$ce0c9da0$@com> <25483.1206248760@turing-police.cc.vt.edu>
In-Reply-To: <25483.1206248760@turing-police.cc.vt.edu>
Subject: RE: [PATCH] give elf_check_arch() a chance for checking endian mismatch
Date: Sun, 23 Mar 2008 17:41:11 +0800
Message-ID: <001701c88cca$0b7c3130$22749390$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciMo5bx8Y+9twxmSNG0ai9fAcxfzQAH2e3w
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Sunday, March 23, 2008 1:06 PM
> To: Roy Lee
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] give elf_check_arch() a chance for checking endian
> mismatch
> 
> On Thu, 20 Mar 2008 03:03:30 +0800, Roy Lee said:
> 
> (Sorry for late reply, catching up finally)
> 
> > I'd like to warn for endianess mismatch, or unsupported feature(
> > hardware float point support) when loading an ELF file.
> 
> > -       if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type !=
> ET_DYN)
> > -               goto out;
> >         if (!elf_check_arch(&loc->elf_ex))
> >                 goto out;
> > +       if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type !=
> ET_DYN)
> > +               goto out;
> 
> It would seem to me that if it isn't an ET_EXEC or ET_DYN, the question of
> whether it passes elf_check_arch() would be rather moot?  In any case, you
> don't get to actually *warn* for it, because you end up with a 'goto out'
> in either case, and elf_check_arch is a pretty small macro on most archs.
> 

Endianness mismatch is not uncommon for bi-endian processors if their user
didn't 
carefully choose their tool-chain or missing flags during compilation.
It makes sense to add some logics for checking and issuing warning when this
happens.

Without changing the order of elf_check_arch(), even if the loaded file is
an 
ET_EXEC or ET_DYN, wrong endianness result in misinterpretation of
'elf_ex.e_type', and
end up skipping elf_check_arch() in which we implement endianness checking
as well as 
other ABI checking logics.

Changing the order of elf_check_arch() should not break current logics on
most archs.
If the loaded file isn't an ET_EXEC, ET_DYN or even not an ELF at all,
it has great chance to return false in the elf_check_arch() since the loaded

file will not satisfy their checking logic. Even if that's not the case, the
postponed
checking of ET_EXEC and ET_DYN will still redirect the flow to 'goto out'.

> Also, if you change the order there, do you want to also change the order
> in load_elf_interp(), where the equivalent test is done?
> 

Yes, I forgot to add them :)

