Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBGUn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBGUn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZBGUnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:43:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:48085 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZBGUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kNmt483Fl3jD/x5gF0Rw+5TIrmWOibE05DxOa6xWgjJ85oxdVSG5wzQVDUyBtNbQoE
         Xy1q3pQz5seXnl868OsZm85eSkUI6hePYuAXT0hoKbm/UDrGvq3rChilZKSOj44j69B2
         /TDJSQm5J7a8fs6BfzF7G5mjbIYAccBX2ap54=
MIME-Version: 1.0
In-Reply-To: <1234028402-4747-1-git-send-email-jirislaby@gmail.com>
References: <1234028402-4747-1-git-send-email-jirislaby@gmail.com>
Date: Sat, 7 Feb 2009 15:43:14 -0500
Message-ID: <73c1f2160902071243t1c00ad1fqf1ae286995f1c1d9@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86_64: fix early_gdt_descr_base mangling
From: Brian Gerst <brgerst@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, pavel@suse.cz,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 7, 2009 at 12:40 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Commit 8c7e58e690ae60ab4215b025f433ed4af261e103
> (x86: rework __per_cpu_load adjustments)
> has broken resume on my machine. On every secondary_startup_64 invocation,
> it adds initial_gs to early_gdt_descr_base.
>
> Fix it by initializing it to per_cpu__gdt_page and adding to it.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Brian Gerst <brgerst@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> ---
>  arch/x86/kernel/head_64.S |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index a0a2b5c..dadca8d 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -215,7 +215,8 @@ ENTRY(secondary_startup_64)
>        movq    initial_gs(%rip), %rax
>        cmpl    $0, per_cpu__cpu_number(%rax)
>        jne     1f
> -       addq    %rax, early_gdt_descr_base(%rip)
> +       addq    $per_cpu__gdt_page, %rax
> +       movq    %rax, early_gdt_descr_base(%rip)
>  1:
>  #endif
>        /*
> @@ -425,7 +426,7 @@ NEXT_PAGE(level2_spare_pgt)
>  early_gdt_descr:
>        .word   GDT_ENTRIES*8-1
>  early_gdt_descr_base:
> -       .quad   per_cpu__gdt_page
> +       .quad   0

The add of the load address isn't done on UP, so this breaks it.

Actually, hold off on this patch.  I see a better way of handling this.

--
Brian Gerst
