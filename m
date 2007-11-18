Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXKRVkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXKRVkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXKRVkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:40:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:46593 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752417AbXKRVkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:40:39 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1//57x4Qzj/HxsnAFMOiiD2VGIQ73kgS/HVAWPrwf
	vZjrayIAzm93Sw
From: Helge Deller <deller@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Date: Sun, 18 Nov 2007 22:40:34 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>
References: <200711182038.22055.deller@gmx.de> <20071118130503.7d5ec842.akpm@linux-foundation.org>
In-Reply-To: <20071118130503.7d5ec842.akpm@linux-foundation.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711182240.35015.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 November 2007, Andrew Morton wrote:
> On Sun, 18 Nov 2007 20:38:21 +0100 Helge Deller <deller@gmx.de> wrote:
> 
> > Title: Add time-based RFC 4122 UUID generator
> > 
> > The current Linux kernel currently contains the generate_random_uuid() 
> > function, which creates - based on RFC 4122 - truly random UUIDs and 
> > provides them to userspace through /proc/sys/kernel/random/boot_id and 
> > /proc/sys/kernel/random/uuid.
> > 
> > This patch additionally adds the "Time-based UUID" variant of RFC 4122, 
> > with which userspace applications can easily get real unique time-based 
> > UUIDs through /proc/sys/kernel/random/uuid_time.
> > A new /proc/sys/kernel/random/uuid_time_clockseq sysfs entry is available,
> > so that the clock_seq value can be retained across system bootups (which
> > is required by RFC 4122).
> > 
> > The attached implementation uses getnstimeofday() to get very fine-grained
> > granularity. This helps, so that userspace tools can get a lot more UUIDs 
> > (if needed) per time than before.
> > A mutex takes care of the proper locking against a mistaken double creation 
> > of UUIDs for simultanious running processes.


> Who will use this feature, and for what?
> (In fact, who uses the existing UUID generators, and for what?)

Current users I know of (but there are more):
- e2fsprogs uses it e.g. to create unique UUIDs for disks (it ships an own library for that)
- http://commons.apache.org/sandbox/id/uuid.html uses it with own libraries
- SAP Netweaver on Linux uses it (http://www.sap.com/platform/netweaver/index.epx)

I'm mostly interested in fixing problems I see with SAP (I'm working for SAP).
SAP Netweaver often needs during a very short time frame lots of unique UUIDs 
(to reference the data afterwards) when new data is imported into the database.
Main problem with current implementations is, is that they don't 100% 
guarantee uniqness of the generated UUIDs. Sometimes, esp. on very fast 
multi-processor machines, double UUIDs are generated and returned to the 
application which is very bad and may result in unreliable behaviour.

Current implemenations use userspace-libraries. In userspace you e.g. can't 
easily protect the uniquness of a UUID against other running _processes_.
If you try do, you'll need to do locking e.g. with shared memory, which can 
get very expensive.
My in-kernel implementation does guarantee the uniquness through the mutex.

The problem will get even worse with virtualization technologies like XEN and
containers. There it's even impossible to protect against processes in other VMs.

Another user which could benefit from it are embedded devices. They could 
drop their userspace-implementations in favour of this smaller kernel version
to create UUIDs for their disks, using it in the webservers, ...

Best regards,
Helge


PS:
I did created bugreports against the e2fsprogs userspace implementation 
at Red Hat and Novell (only accessible for RH/Novell employees), but as I 
explained above, the userspace-implementation may not be sufficient:
https://bugzilla.redhat.com/show_bug.cgi?id=233471 
https://bugzilla.redhat.com/show_bug.cgi?id=218606 
https://bugzilla.novell.com/show_bug.cgi?id=189640
