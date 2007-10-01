Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXJAStX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXJAStX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXJAStO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:49:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:61646 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbXJAStN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ll4RVce2BT8UQdxOggs8tOdfJ/bhUbwQPZtCihW7dQryCNLlgtMpMrwjKXDffW6QU714wBcBMpdgtwNzyPlVQcXrBySLb3rUDUSxMDz2Mp1rAP0+P+PXXOtblFRGlQEqv1tRyVzrmGScpMYEAoRpRyRmfo/zw4IqFCuiD5dl2zw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: F_DUPFD_CLOEXEC implementation
Date: Mon, 1 Oct 2007 19:49:03 +0100
User-Agent: KMail/1.9.1
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <200710011107.15846.vda.linux@googlemail.com> <20071001181648.GB8181@ftp.linux.org.uk>
In-Reply-To: <20071001181648.GB8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011949.03482.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 19:16, Al Viro wrote:
> 	* it's on a bunch of cyclic lists.  Have its neighbor
> go away while you are doing all that crap => boom
> 	* there's that thing call current position...  It gets buggered.
> 	* overwriting it while another task might be in the middle of
> syscall involving it => boom

Hm, I suspected that it's herecy. Any idea how to do it cleanly?

> 	* non-cooperative tasks reading *in* *parallel* from the same
> opened file are going to have a lot more serious problems than agreeing
> on O_NONBLOCK anyway, so I really don't understand what the hell is that for.

They don't even need to read in parallel, just having shared fd is enough.
Think about pipes, sockets and terminals. A real-world scenario:

* a process started from shell (interactive or shell script)
* it sets O_NONBLOCK and does a read from fd 0...
* it gets killed (kill -9, whatever)
* shell suddenly has it's fd 0 in O_NONBLOCK mode
* shell and all subsequent commands started from it unexpectedly have
  O_NONBLOCKed stdin.
--
vda
