Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZKCOdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZKCOdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZKCOdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:33:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZKCOdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:33:02 -0500
Date: Tue, 3 Nov 2009 12:32:50 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] Handle asynchronous page fault in a PV guest.
Message-ID: <20091103143250.GD10084@amt.cnet>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-4-git-send-email-gleb@redhat.com> <20091103141423.GC10084@amt.cnet> <20091103142533.GN27911@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103142533.GN27911@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 04:25:33PM +0200, Gleb Natapov wrote:
> On Tue, Nov 03, 2009 at 12:14:23PM -0200, Marcelo Tosatti wrote:
> > On Sun, Nov 01, 2009 at 01:56:22PM +0200, Gleb Natapov wrote:
> > > Asynchronous page fault notifies vcpu that page it is trying to access
> > > is swapped out by a host. In response guest puts a task that caused the
> > > fault to sleep until page is swapped in again. When missing page is
> > > brought back into the memory guest is notified and task resumes execution.
> > 
> > Can't you apply this to non-paravirt guests, and continue to deliver
> > interrupts while waiting for the swapin? 
> > 
> > It should allow the guest to schedule a different task.
> But how can I make the guest to not run the task that caused the fault?

Any attempt to access the swapped out data will cause a #PF vmexit,
since the translation is marked as not present. If there's swapin in
progress, you wait for that swapin, otherwise start swapin and wait.

Its not as efficient as paravirt because you have to wait for a timer
interrupt and the guest scheduler to decide to taskswitch, but OTOH its
transparent.

