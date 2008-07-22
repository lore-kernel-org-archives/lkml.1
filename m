Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYGVMVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYGVMVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYGVMVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:21:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:63680 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYGVMVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:21:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PzSbDldlrXGucImS8BIunHRZBTyPxIzvUTnXGnAXUaIeZutLhNIjZMIUwI15QSXqaA
         PC1ebUE2xWPF2KhJ2vdi8pgjxubVPi+90gWzOVy8gP4FiVgLgFq4EuWrmYaHmmWJLGt9
         Y+XVwBmVTvLWG8c2aRzrNntNe5KCJnm0BzKqk=
Message-ID: <cfd18e0f0807220521x5faea19bn1f545b23b84ead6a@mail.gmail.com>
Date: Tue, 22 Jul 2008 14:21:20 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] coredump: format_corename: don't append .%pid if multi-threaded
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Roland McGrath" <roland@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
In-Reply-To: <20080722121824.GB1383@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org>
	 <20080721102940.666d733d@the-village.bc.nu>
	 <20080721210121.C5E741541A5@magilla.localdomain>
	 <20080721221416.6d4f9014@lxorguk.ukuu.org.uk>
	 <20080722113731.GA1383@tv-sign.ru> <20080722121824.GB1383@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 2:18 PM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> If the coredumping is multi-threaded, format_corename() appends .%pid
> to the corename. This was needed before the proper multi-thread core
> dump support, now all the threads in the mm go into a single unified
> core file.
>
> Remove this special case, it is not even documented and we have "%p"
> and core_uses_pid.

Hi Oleg,

I have not thought about this at any length, but one question that
jumps to mind: could this feature still be useful for LinuxThreads,
where each thread does indeed have a separate PID?

Cheers,

Michael

>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- 26-rc2/fs/exec.c~FORMAT_CORENAME_NO_MT_PID  2008-07-22 15:42:15.000000000 +0400
> +++ 26-rc2/fs/exec.c    2008-07-22 15:46:04.000000000 +0400
> @@ -1373,7 +1373,7 @@ EXPORT_SYMBOL(set_binfmt);
>  * name into corename, which must have space for at least
>  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
>  */
> -static int format_corename(char *corename, int nr_threads, long signr)
> +static int format_corename(char *corename, long signr)
>  {
>        const char *pat_ptr = core_pattern;
>        int ispipe = (*pat_ptr == '|');
> @@ -1480,8 +1480,7 @@ static int format_corename(char *corenam
>         * If core_pattern does not include a %p (as is the default)
>         * and core_uses_pid is set, then .%pid will be appended to
>         * the filename. Do not do this for piped commands. */
> -       if (!ispipe && !pid_in_pattern
> -           && (core_uses_pid || nr_threads)) {
> +       if (!ispipe && !pid_in_pattern && core_uses_pid) {
>                rc = snprintf(out_ptr, out_end - out_ptr,
>                              ".%d", task_tgid_vnr(current));
>                if (rc > out_end - out_ptr)
> @@ -1745,7 +1744,7 @@ int do_coredump(long signr, int exit_cod
>         * uses lock_kernel()
>         */
>        lock_kernel();
> -       ispipe = format_corename(corename, retval, signr);
> +       ispipe = format_corename(corename, signr);
>        unlock_kernel();
>        /*
>         * Don't bother to check the RLIMIT_CORE value if core_pattern points
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
