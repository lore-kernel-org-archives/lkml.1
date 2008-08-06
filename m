Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbYHFMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbYHFMXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYHFMVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:21:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:29458 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYHFMVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uuj+XoBe2D8QGvo5RCtr27v/XHNqKpaBAurvUMchUI2z4kSIAceDfyIWmCbU31N7jR
         gqx/zDouGT2lKFWBE5D4oWign9Bc2A7pvc2GlPsx9nZ1M7HB9MkgUXIB30SNnDqX14M0
         CiyhXcd8xBvJjhtYNoFvRP3IoztD0NkZVTqEk=
Message-ID: <863e9df20808060521w5df7e7bj395803e8cc63434b@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:51:15 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: jmerkey@wolfmountaingroup.com
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200808050626.m756QZ1g003755@wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 11:56 AM,  <jmerkey@wolfmountaingroup.com> wrote:
> @@ -850,6 +871,10 @@
>  #ifdef CONFIG_KPROBES
>  void __kprobes do_int3(struct pt_regs *regs, long error_code)
>  {
> +#ifdef CONFIG_MDB
> +        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
> +           return;
> +#endif // CONFIG_MDB
>        trace_hardirqs_fixup();
>
>        if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
> @@ -865,6 +890,16 @@
>  }
>  #endif

If the mdb() call modifies the IF flag in regs, then it should
probably be called after trace_hardirqs_fixup. Best to keep it behind
notify_die() ensuring that kprobes handles all breakpoints first.
Otherwise at least the mdb function (and others in its call chain)
should be marked as __kprobes.

-- Abhishek Sagar
