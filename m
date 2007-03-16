Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbXCPFQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbXCPFQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 01:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXCPFQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 01:16:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:40684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXCPFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 01:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uO+iPHQ69lT6qDLzpLXWip0taGWJBCUi05NcDsGRbk3xf3qSCf+6HfNuueFalUhegSue7UI/lsMi7mLPhj2TPGK8VR1qmlZgmeGDgWYtt/3dGxkJMJJ5VkLSpchtgcuwyRUeIOwpWh7iIxp9ufvWh3ZMB68N1/9f4bm3/rvR/Mg=
Message-ID: <a36005b50703152216s6c2fce0ck71d41a124940265f@mail.gmail.com>
Date: Thu, 15 Mar 2007 21:16:22 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703071406100.12756@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
	 <45EF20F7.1050307@goop.org>
	 <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
	 <45EF2DFF.4060209@goop.org>
	 <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
	 <a36005b50703071401m2b166832rb06f4cf73224f45e@mail.gmail.com>
	 <Pine.LNX.4.64.0703071406100.12756@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> Let's do this. How about you throw this way one of the case that would
> possibly break, and I test it?

Since you make such claims I assume your signalfd() implementation
considers a signal delivered once it is reported to an epoll() caller.
 Right?

This is not what you really want, at least not in all cases.  A signal
might be something you want to react on right away.  Unless
pthread_kill() is used it is delivered to the _process_ and not a
specific thread.  But this means if epoll() reports two events to one
thread calling epoll() (one of them being a signal) and this thread is
then stuck processing the other request, the signal is not handled
even though there might be a second or third thread available to
receive the signal.  Those threads have the same right to receive the
signal and the current implementation always looks for the
best/fastest way to deliver the signal.

This means to me that reporting the signal in epoll() does _not_ mark
the signal as handled.  Somehow (probably using the signalfd()
descriptor) the thread must explicitly request the signal to be
delivered.  But if you do this the epoll() handling is fantastically
racy if the signal is not blocked.
