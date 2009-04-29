Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZD2UCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZD2UCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZD2UCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:02:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZD2UCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:02:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=gpSy78xLLQRgikNIEdW2YEXyL7ptXoZG+CbK4tnxzcStirRtE95eG0edaGLWK2dTF
	CS8rH+oteaopvGEMQjPJQ==
Date: Wed, 29 Apr 2009 13:02:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <righi.andrea@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent divide error for small values of
 vm_dirty_bytes
In-Reply-To: <20090429093449.GB3151@linux>
Message-ID: <alpine.DEB.2.00.0904291258520.31046@chino.kir.corp.google.com>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com> <1240994676.8021.83.camel@laptop> <20090429093449.GB3151@linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Andrea Righi wrote:

> On Wed, Apr 29, 2009 at 10:44:36AM +0200, Peter Zijlstra wrote:
> > On Wed, 2009-04-29 at 10:29 +0200, Andrea Righi wrote:
> > > Avoid to set less than two pages for vm_dirty_byte: this is necessary to avoid
> > > potential division by 0 (like the following) in get_dirty_limits().
> > 
> > isn't changing the .extra1 in the sysctl table a better fix?
> 
> I thought about that and probably you're right. But, in the first case
> if the user writes a value < 2*PAGE_SIZE vm_dirty_bytes is explicitly
> set to 2*PAGE_SIZE. In the other case the value is just ignored.
> 
> Maybe the second case could generate some unexpected behaviours for
> the user. For example, the user writes X < 2*PAGE_SIZE to
> /proc/sys/vm/dirty_bytes, and could think that the system has started to
> use this new configuration, but it isn't actually.
> 
> So, probably the best way is to change .extra1 and add a note in the
> documentation (see below).
> 

This is only caused by bdi, not by the dirty ratio itself; shouldn't the 
appropriate fix be in calc_period_shift()?  In other words, allow 
dirty thresholds to be less than 2 * PAGE_SIZE but prevent the bdi 
fraction from having a zero denominator?
