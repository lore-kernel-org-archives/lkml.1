Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYJ2NRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYJ2NRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYJ2NRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:17:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:41724 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYJ2NRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=eyuBPOar5Uy2kTSYpZUlVtxH96YBzCovBwAit3rLfRt09fl1xa8E+3Mbz/Y/lzaOdy
         p+K5AKa+h5XZupipc2VB/daBYuDysSRnt2fPBdBayMuk8LeShbVvMsMZqcYzUxER9REV
         SHcZarutrRjT+mSEfEyG2LlHvYlvgvuSmoCMs=
Message-ID: <517f3f820810290617m49b5deccu5d639cd0d3c94592@mail.gmail.com>
Date: Wed, 29 Oct 2008 08:17:36 -0500
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Halesh S" <halesh.s@india.com>
Subject: Re: parent process behaviour to signal after vfork()
Cc: linux-kernel@vger.kernel.org, "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <loom.20081028T062822-852@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20081028T062822-852@post.gmane.org>
X-Google-Sender-Auth: 19b2237d8248e709
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 1:43 AM, Halesh S <halesh.s@india.com> wrote:
> Hi,
>
> Please find the below test code...
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <signal.h>
> #include <unistd.h>
> int x = 0;
> typedef void (*sighandler_t)(int);
> void fun()
> {
>  printf("SIGNAL CAUGHT\n");
> }
>
> int main()
> {
>  int pid;
>
>  signal(SIGINT, (sighandler_t)fun);
>  signal(SIGSEGV, (sighandler_t)fun);
>  pid = vfork();
>
>  if ( pid == 0 ) {
>    printf(" I am child - %d \n", pid);
>    x++;
>    raise(SIGINT);
>    printf("x = %d\n", x);
>    exit(0);
>  }
>  else {
>    printf(" I am parent - %d\n", pid);
>    raise(SIGSEGV);
>    printf("x = %d\n", x);
>  }
> }
>
> Why the parent process is not able to handle/respond the signals, when a child
> once handles the signal, child is created using vfork().
>
> In vfork() man page -
>       "Signals to the parent arrive after the child releases the parent's
>       memory."
>
> How to make sure that child has released the parent memory..??

That happens when the child does execve(2) or _exit(2).  The man-page could be a little clearer on that point (it implies it, but not very clearly).  For man-pages-3.12, I've made the change below.

Cheers,

Michael

diff --git a/man2/vfork.2 b/man2/vfork.2
index 55044ad..8a7ed50 100644
--- a/man2/vfork.2
+++ b/man2/vfork.2
@@ -94,7 +94,10 @@ but may call
 .PP
 Signal handlers are inherited, but not shared.
 Signals to the parent
-arrive after the child releases the parent's memory.
+arrive after the child releases the parent's memory (i.e., after the child calls
+.BR _exit (2)
+or
+.BR execve (2)).
 .SS "Historic Description"
 Under Linux,
 .BR fork (2)

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html

