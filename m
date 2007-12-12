Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbXLLSCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbXLLSCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbXLLSCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:02:46 -0500
Received: from phunq.net ([64.81.85.152]:60587 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751518AbXLLSCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:02:45 -0500
From: Daniel Phillips <phillips@phunq.net>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: A peek at the future of storage
Date: Wed, 12 Dec 2007 10:02:44 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200712120846.18320.phillips@phunq.net> <20071212174613.GA16656@fieldses.org>
In-Reply-To: <20071212174613.GA16656@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121002.44643.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 December 2007 09:46, J. Bruce Fields wrote:
> On Wed, Dec 12, 2007 at 08:46:18AM -0800, Daniel Phillips wrote:
> > Incidentally, we ran our tests with 128 knfsd threads.  The default
> > of 8 threads produces miserable performance on the SSD, which gave
> > us a good scare on our initial test run.  It would be very nice to
> > implement an algorithm to scale the knfsd thread pool
> > automatically, in order to eliminate this class of thing that can
> > go wrong.  If somebody became inspired to take on that little
> > project that would be great, otherwise it is in our pipeline for,
> > hmm, Christmas delivery.  (Exactly which Christmas is left
> > unspecified.)
>
> People have proposed writing a daemon that just reads
> /proc/net/rpc/nfsd periodically and uses that to adjust the number of
> threads from userspace, probably subject to some limits in a config
> file someplace. (Think that could do the job, or is there some reason
> this would be easier in the kernel?)

I didn't actually say "kernel", though that was what I was thinking, 
perhaps just out of habit.  It seems to me it would be a relatively 
small change to the existing code, essentially just finishing the idea, 
without needing to be patched up by userspace. 

So how would a userspace daemon know that kernel is blocking and new 
threads are needed?  In kernel this is pretty easy: when a new request 
arrives, look on the thread list and if none are available, generate a 
new one.  Something special needs to be done to handle the case where 
there are no threads available because they are all piled up on a 
semaphore due to, for example, somebody unplugging the network cable 
for a remote disk.  We have to avoid generating infinite threads in 
that case.  Ideas?

Daniel
