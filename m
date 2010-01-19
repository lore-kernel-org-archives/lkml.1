Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596Ab0ASRqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0ASRqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524Ab0ASRqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:46:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab0ASRpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:45:55 -0500
Date: Tue, 19 Jan 2010 19:44:38 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
Message-ID: <20100119174438.GA19450@redhat.com>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com>
 <1262700774-1808-5-git-send-email-gleb@redhat.com>
 <1263490267.4244.340.camel@laptop>
 <20100117144411.GI31692@redhat.com>
 <4B541D08.9040802@zytor.com>
 <20100118085022.GA30698@redhat.com>
 <4B5510B1.9010202@zytor.com>
 <20100119065537.GF14345@redhat.com>
 <4B55E5D8.1070402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B55E5D8.1070402@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 09:03:20AM -0800, H. Peter Anvin wrote:
> On 01/18/2010 10:55 PM, Gleb Natapov wrote:
> >>
> >> What I mean is that vector 14 is page faults -- that's what it is all
> >> about.  Why on Earth do you need another vector?
> >>
> > Because this is not usual pagefault that tell the OS that page is not
> > mapped. This is a notification to a guest OS that the page it is trying
> > to access is swapped out by the host OS. There is nothing guest can do
> > about it except schedule another task. So the guest should handle both
> > type of exceptions: usual #PF when page is not mapped by the guest and
> > new type of notifications. Ideally we would use one of unused exception
> > vectors for new type of notifications.
> > 
> 
> Ah, this kind of stuff.  We have talked about this in the past, and the
> right way to do that is to have the guest OS pick a vector our of the
> standard 0x20-0xff range, and then notify the hypervisor via a hypercall
> which vector to use.
> 
> In Linux this means marking it as a system vector.  Note that there are
> real hardware system vectors which will be mutually exclusive with this,
> e.g. the UV one.

Yes it can be done this way and I'll look into it once more. Using
exception vector is more convenient for three reasons: it allows to pass
additional data in error code, it doesn't require guest to issue EOI,
exception can be injected when interrupts are disabled by a guest. The
last one is not important for now since host doesn't inject notifications
when interrupts are disabled currently. Having Intel allocate one
exception vector for hypervisor use would be really nice though.

--
			Gleb.
