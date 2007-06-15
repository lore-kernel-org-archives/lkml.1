Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXFOUDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXFOUDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXFOUDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:03:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:60746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXFOUDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,426,1175497200"; 
   d="scan'208";a="257398816"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] ia64: Scalability improvement of gettimeofday with jitter compensation
Date: Fri, 15 Jun 2007 13:03:08 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A01B3475A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0706151040180.9132@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ia64: Scalability improvement of gettimeofday with jitter compensation
Thread-Index: Acevd/b8F9uQzZuVQ7OINcpmQcThGwADSHJg
From: "Luck, Tony" <tony.luck@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Cc: <linux-ia64@vger.kernel.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Jun 2007 20:03:09.0695 (UTC) FILETIME=[324208F0:01C7AF88]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >   ret = cmpxchg(&last_cycle, last, new);
> >   if (ret == last)
> >     return new; /* you win! */
> >   else
> >     return ret; /* you lose. ret is winner's new */
>
> Interesting solution. But there may be multiple updates of last happening. 
> Which of the winners is the real winner?

It might not matter.  Let's look at how good a guarantee an
application can expect from gettimeofday().  First of all
there may be arbitrary delays either before, or after the
kernel comes up with the "current" time since the process
could be context switched in the glibc prologue or epilogue
for the system call.  So I think that the best that an
application can expect is:

 Given two calls to gettimeofday A and B, where through some
 external syncronization it is known that call B is initiated
 after A has completed, then B shall not return a time value
 lower than that returned by A.

Now if that is the strongest ordering that an application can
expect (and I'm not completely convinced that I'm right, other
definitions gratefully accepted), then it would appear that
is is just over-engineering to worry too much about calls that
collide inside the kernel (since these don't satisfy the
"B initiated after A completes" clause of my definition).

-Tony

[For some 50 year old British humour on the subject of time,
 read: http://www.hexmaster.com/goonscripts/what_time_is_it.html ]
