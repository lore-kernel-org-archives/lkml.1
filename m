Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbXJGKI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbXJGKI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 06:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXJGKIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 06:08:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:47561 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751042AbXJGKIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 06:08:49 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19+mLB7Gj1+yIjTutTmuz+01gmevihy6eLe0b0YzN
	ZHY1BYKutgf7Vp
From: Helge Deller <deller@gmx.de>
To: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Time-based RFC 4122 UUID generator
Date: Sun, 7 Oct 2007 12:08:10 +0200
User-Agent: KMail/1.9.7
References: <200710061553.37311.deller@gmx.de> <20668.1191728530@turing-police.cc.vt.edu>
In-Reply-To: <20668.1191728530@turing-police.cc.vt.edu>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710071208.11030.deller@gmx.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Valdis,

On Sunday 07 October 2007, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 06 Oct 2007 15:53:37 +0200, Helge Deller said:
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -1157,6 +1158,8 @@ void generate_random_uuid(unsigned char uuid_out[16])
> >  	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
> >  	/* Set the UUID variant to DCE */
> >  	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
> > +	/* Set multicast bit to avoid conflicts with NIC MAC addresses */
> > +	uuid_out[10] |= 0x80;
> >  }
> 
> 
> Erm, was it *intended* that you also changed the behavior of generate_random_uuid()?

Thanks that you ask! 
I really should have mentioned it in my initial posting.

Yes, this change was intentional, as it in fact fixes a possible bug in the original code.
Section 4.1.6 in RFC 4122 states regarding the "NodeID":
:  For systems with no IEEE address, a randomly or pseudo-randomly
:  generated value may be used; see Section 4.5.  The multicast bit must
:  be set in such addresses, in order that they will never conflict with
:  addresses obtained from network cards. 

So up to now it was just pure ("random") luck if this bit was set or not.

While at it...
My patch addressed another small non-critical glitch in the current implementation as well.
An "strace cat /proc/sys/kernel/random/uuid" shows:
: ....
: open("/proc/sys/kernel/random/uuid", O_RDONLY|O_LARGEFILE) = 3
: fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
: read(3, "378244d0-9b27-4f92-8b3a-386ed526"..., 1024) = 37
: write(1, "378244d0-9b27-4f92-8b3a-386ed526"..., 37378244d0-9b27-4f92-8b3a-386ed52692a8) = 37
: read(3, "", 1024)                       = 0
: close(3)                                = 0
: ...
The first read() returns the newly generated random uuid.
The second read() just returns zero, but the current implementation then already created a new uuid which wasn't used at all.
Although this is not critical, it was nevertheless leaking unnecessarily entropy from the pool.
For the case of the new time-based UUIDs it was worse. It unnecessary incremented the clock_seq number.
This issue is addressed by this part of my patch (esp.: "*ppos > 0"):
@@ -1191,13 +1317,13 @@ static int proc_do_uuid(ctl_table *table, int write, struct file *filp,
        ctl_table fake_table;
        unsigned char buf[64], tmp_uuid[16], *uuid;
 
-       uuid = table->data;
-       if (!uuid) {
-               uuid = tmp_uuid;
-               uuid[8] = 0;
+       /* random/time UUIDs need to be read completely at once */
+       if (table->ctl_name != RANDOM_BOOT_ID && *ppos > 0) {
+               *lenp = 0;
+               return 0;
        }

Helge
