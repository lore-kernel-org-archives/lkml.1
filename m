Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXI3X7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXI3X7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXI3X66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:58:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbXI3X65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cnvbJ6JG09P86lI5//wlLCltXdXsm2WHsrcHbXGNwyeipOiFvkmBv7UqEIZ/zS8oZqMQSA3VX8TRvQa4og3EYsv938zAuAfYLcL0QVRHIFw572MMUiMBWaRBOdjXZvs4F9OIpaVrL2CpRkRlhLj/i3IRHVroHgLr+dHWsngKXaI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
Date: Mon, 1 Oct 2007 00:58:49 +0100
User-Agent: KMail/1.9.1
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <200709300131.49320.vda.linux@googlemail.com> <Pine.LNX.4.64.0709301605340.19355@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0709301605340.19355@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710010058.49242.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 00:11, Davide Libenzi wrote:
> On Sun, 30 Sep 2007, Denys Vlasenko wrote:
> 
> > Hi Ulrich,
> > 
> > On Friday 28 September 2007 18:34, Ulrich Drepper wrote:
> > > One more small change to extend the availability of creation of
> > > file descriptors with FD_CLOEXEC set.  Adding a new command to
> > > fcntl() requires no new system call and the overall impact on
> > > code size if minimal.
> > 
> > Tangential question: do you have any idea how userspace can
> > safely do nonblocking read or write on a potentially-shared fd?
> > 
> > IIUC, currently it cannot be done without races:
> > 
> > old_flags = fcntl(fd, F_GETFL);
> > ...other process may change flags!...
> > fcntl(fd, F_SETFL, old_flags | O_NONBLOCK);
> > read(fd, ...)
> > ...other process may see flags changed under its feet!...
> > fcntl(fd, F_SETFL, old_flags);
> > 
> > Can this be fixed?
> 
> I'm not sure I understood correctly your use case. But, if you have two 
> processes/threads randomly switching O_NONBLOCK on/off, your problems 
> arise not only the F_SETFL time.

My use case is: I want to do a nonblocking read on descriptor 0 (stdin).
It may be a pipe or a socket.

There may be other processes which share this descriptor with me,
I simply cannot know that. And they, too, may want to do reads on it.

I want to do nonblocking read in such a way that neither those other
processes will ever see fd switching to O_NONBLOCK and back, and
I also want to be safe from other processes doing the same.

I don't see how this can be done using standard unix primitives.
--
vda
