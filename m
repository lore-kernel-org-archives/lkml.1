Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZBXUgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZBXUgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZBXUg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:36:27 -0500
Received: from host64.cybernetics.com ([98.174.209.230]:4031 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZBXUg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:36:27 -0500
Message-ID: <49A45A48.6020805@cybernetics.com>
Date: Tue, 24 Feb 2009 15:36:24 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] [2.6.29] epoll: fix for epoll_wait sometimes returning
 events on closed fds
References: <49A42DDE.8060605@cybernetics.com> <49A4387D.2020801@cosmosbay.com> <49A43FF0.2070703@cybernetics.com> <49A44FEB.6000803@cosmosbay.com>
In-Reply-To: <49A44FEB.6000803@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> I believe Davide already said that close() meant the real close, not
> the file descriptor freeing. 
>
> And current documentations clearly states it, maybe your man page is too old ?
>
> ---
>
> Q6  Will closing a file descriptor cause it to be removed from all epoll sets automatically?
>
> A6  Yes,  but  be  aware  of  the  following  point.   A  file descriptor is a reference to an open file description (see
>     open(2)).  Whenever a descriptor is duplicated via dup(2), dup2(2), fcntl(2) F_DUPFD, or fork(2), a new file descriptor  referring  to  the same open file description is created.  An open file description continues to exist until all
>     file descriptors referring to it have been closed.  A file descriptor is removed from an epoll set only after all the
>     file  descriptors  referring to the underlying open file description have been closed (or before if the descriptor is
>     explicitly removed using epoll_ctl() EPOLL_CTL_DEL).  This means that even after a file descriptor that is part of an
>     epoll set has been closed, events may be reported for that file descriptor if other file descriptors referring to the
>     same underlying file description remain open.
>
>
>
>
>   
Ugh.  The manpage on Ubuntu 8.04 that I am using doesn't contain this
lengthy caveat; it just says "A6     Yes."  To me it sounds like the
(newer) manpage is just documenting away a bug/misfeature with "It's
supposed to do that.  Gives it character." rather than expecting the
kernel developers to make the API behave in a more reasonable way.  Just
my opinion; others may agree or disagree.

If the officially-sanctioned epoll interface is supposed to report
events on fds that were added, duped, and then the original fd closed,
then my patch will probably break that behavior.  In that case, it will
be more difficult to fix problem that my patch is trying to fix (which
doesn't involve dup, dup2, fcntl, fork, etc.).  So before I try to think
of another way, let me ask: do we want to fix the problem that I am
reporting, or just document it away in the manpage as (apparently) has
been done before?

Tony

