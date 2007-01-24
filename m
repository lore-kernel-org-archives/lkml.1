Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbXAXVSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbXAXVSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXAXVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:18:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:45934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXAXVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:18:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YyaFk5Tb1Z2XuLZXHPiU/D1Cb7FPTAcRzobZ90qDSxnXfUHydi04HVcOeUjPlsJVE7vtDU0Q4qOEgFb1fWO41s0LUxbtgRupmjyTFk/U0Y3Ipy4imZbRL9x5JpUUJhbd7QLhkRxmp1xgsNE/14MzX1Sh957HG5TEZPdQ/x7qFPI=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: O_DIRECT question
Date: Wed, 24 Jan 2007 22:15:47 +0100
User-Agent: KMail/1.8.2
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       kenneth.w.chen@intel.com, akpm@osdl.org
References: <6d6a94c50701101857v2af1e097xde69e592135e54ae@mail.gmail.com> <200701212102.43028.vda.linux@googlemail.com> <45B4E3A3.40706@cfl.rr.com>
In-Reply-To: <45B4E3A3.40706@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701242215.47777.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 January 2007 17:17, Phillip Susi wrote:
> > You do not need to know which read() exactly failed due to bad disk.
> > Filename and offset from the start is enough. Right?
> > 
> > So, SIGIO/SIGBUS can provide that, and if your handler is of
> > 	void (*sa_sigaction)(int, siginfo_t *, void *);
> > style, you can get fd, memory address of the fault, etc.
> > Probably kernel can even pass file offset somewhere in siginfo_t...
> 
> Sure... now what does your signal handler have to do in order to handle 
> this error in such a way as to allow the one request to be failed and 
> the task to continue handling other requests?  I don't think this is 
> even possible, yet alone clean.

Actually, you have convinced me on this. While it's is possible
to report error to userspace, it will be highly nontrivial (read:
bug-prone) for userspace to catch and act on the errors.

> > You think "Oracle". But this application may very well be
> > not Oracle, but diff, or dd, or KMail. I don't want to care.
> > I want all big writes to be efficient, not just those done by Oracle.
> > *Including* single threaded ones.
> 
> Then redesign those applications to use aio and O_DIRECT.  Incidentally 
> I have hacked up dd to do just that and have some very nice performance 
> numbers as a result.

I will still disagree on this point (on point "use O_DIRECT, it's faster").
There is no reason why O_DIRECT should be faster than "normal" read/write
to large, aligned buffer. If O_DIRECT is faster on today's kernel,
then Linux' read()/write() can be optimized more.

(I hoped that they can be made even *faster* than O_DIRECT, but as I said,
you convinced me with your "error reporting" argument that reads must still
block until entire buffer is read. Writes can avoid that - apps can do
fdatasync/whatever to make sync writes & error checks if they want).
--
vda
