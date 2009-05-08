Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbZEHTCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbZEHTCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763501AbZEHTCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:02:18 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:20121
	"EHLO WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762998AbZEHTCQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:02:16 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 15:02:16 EDT
X-BigFish: VPS-18(zz1432R4015L1805Mzz1202hzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KJC9I6-02-GSS-01
x-mimeole: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][KVM][retry 2] Add support for Pause Filtering to AMD SVM
Date: Fri, 8 May 2009 13:47:04 -0500
Message-ID: <6453C3CB8E2B3646B0D020C11261327303620947@sausexmb4.amd.com>
In-Reply-To: <4A047D86.1070407@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][KVM][retry 2] Add support for Pause Filtering to AMD SVM
Thread-Index: AcnQDQYFuSF8yShmRASM/sV+ee0yDQAACb9w
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <200905081203.55484.mark.langsdorf@amd.com> <4A047D86.1070407@redhat.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Avi Kivity" <avi@redhat.com>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, <kvm@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 May 2009 18:47:05.0198 (UTC) FILETIME=[61DFD0E0:01C9D00D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's the differences wrt retry 1?

I'm using git format-patch as you requested.
 
> > This feature creates a new field in the VMCB called Pause
> > Filter Count.  If Pause Filter Count is greater than 0 and
> > intercepting PAUSEs is enabled, the processor will increment
> > an internal counter when a PAUSE instruction occurs instead
> > of intercepting.  When the internal counter reaches the
> > Pause Filter Count value, a PAUSE intercept will occur.
> >
> > This feature can be used to detect contended spinlocks,
> > especially when the lock holding VCPU is not scheduled.
> > Rescheduling another VCPU prevents the VCPU seeking the
> > lock from wasting its quantum by spinning idly.
> >
> > Experimental results show that most spinlocks are held
> > for less than 1000 PAUSE cycles or more than a few
> > thousand.  Default the Pause Filter Counter to 3000 to
> > detect the contended spinlocks.
> 
> 3000.

Thanks, I keep missing that.
 
> > On a 24 core system running 4 guests each with 16 VCPUs,
> > this patch improved overall performance of each guest's
> > 32 job kernbench by approximately 1%.  Further performance
> > improvement may be possible with a more sophisticated
> > yield algorithm.
> >   
> 
> Like I mentioned earlier, I don't think schedule() does 
> anything on CFS.
> 
> Try sched_yield(), but set /proc/sys/kernel/sched_compat_yield.

Will do.

> > +static int pause_interception(struct vcpu_svm *svm, struct 
> kvm_run *kvm_run)
> > +{
> > +	/* Simple yield */
> > +	vcpu_put(&svm->vcpu);
> > +	schedule();
> > +	vcpu_load(&svm->vcpu);
> > +	return 1;
> > +}
> > +
> >   
> 
> You don't need to vcpu_put() and vcpu_load().  The scheduler 
> will call them for you if/when it switches tasks.

I was waiting for feedback from Ingo on that issue, but I'll
try sched_yield() instead.

-Mark Langsdorf
Operating System Research Center
AMD

