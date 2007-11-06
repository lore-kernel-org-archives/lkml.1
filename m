Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbXKFMUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbXKFMUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbXKFMU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:20:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53283 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbXKFMU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:20:27 -0500
Subject: Re: 2.6.24-rc1 - Regularly getting processes stuck in D state on
	startup
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David <david@unsolicited.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20071106174626.3c7d3a14.sfr@canb.auug.org.au>
References: <472F5F8B.7090200@unsolicited.net>
	 <20071106174626.3c7d3a14.sfr@canb.auug.org.au>
Content-Type: multipart/mixed; boundary="=-eHZsKawzd8v+IjsQw5HW"
Date: Tue, 06 Nov 2007 13:20:11 +0100
Message-Id: <1194351611.6289.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eHZsKawzd8v+IjsQw5HW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-11-06 at 17:46 +1100, Stephen Rothwell wrote:
> On Mon, 05 Nov 2007 18:23:07 +0000 David <david@unsolicited.net> wrote:
> >
> > I've been testing rc1 for a week or so, and about 25% of the time I'm
> > seeing Firefox and Thunderbird getting stuck in 'D' state as they startup.
> > 
> > I've attached the output of Sysrq-T to this mail... system is a
> > dual-core AMD64, and files are on a RAID-1 root partition connected two
> > SATA disks on the on-board NVidia controller. I've had no problems
> > before .24 rc1
> 
> I am seeing something very similar on a PowerPC machine where copying a
> file from an LVM volume with ext3 on it to a simple scsi partition (again
> ext3) on the same disk will hang in congestion_wait.  If I am patient
> enough, the copy makes very slow progress.  A kill -9 will kill it
> eventually, but a simple control-C will not.
> 
> This hang occurs more often than not (and usually when I am trying to
> install a new kernel into /boot for testing :-)).
> 
> I don't have access to the machine today, but if more information would
> be useful, I could boot into 2.6.24-rc1-<mumble> again tomorrow.

LVM will provide a different BDI even though it could be on the same
disk as another 'real' partition. Still that should not make the copy
take that long.

I tried copying a 1M file from the lvm to a real partition on the same
disk (after ensuring the lvm had all the dirty limit), works like
advertised.

x86_64 SMP PREEMPT v2.6.24-rc1-748-g2655e2c + the four attached patches
rawhide x86_64 userland

To test this scenario I made an lvm thingy /dev/lvm/foo on /dev/sdb6

/ -> /dev/sda3
/dev/sdb1 /mnt/sdb1
/dev/lvm/foo -> /mnt/foo

All ext3 for this test.

The pretty numbers come from:

# while sleep 1; do cat /sys/class/bdi/*/bdi_dirty_kb | awk '{t=$0; n+=
$0; while (getline) { t=t " " $0; n+=$0; } ; getline total <
"/sys/class/bdi/sda/dirty_kb" ; print t " : " n "/" total }' ; done

while doing:

# dd if=/dev/zero of=/mnt/foo/zero bs=4096 count=$((1024*1024/4))

dm-0 ............................................. sda sdb ..........

0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 159440 0 0 0 0 0 0 : 159440/193540
5848 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 89588 0 0 0 0 0 0 : 95436/193092
41488 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 82908 0 0 0 0 0 0 : 124396/192576
69984 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 62100 0 0 0 0 0 0 : 132084/191952
93488 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 67132 0 0 0 0 0 0 : 160620/191752
114452 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 57676 0 0 0 0 0 0 : 172128/191696
124260 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 53508 0 0 0 0 0 0 : 177768/191544
138072 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 53140 0 0 0 0 0 0 : 191212/191252
145004 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 45748 0 0 0 0 0 0 : 190752/190804
155408 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 35508 0 0 0 0 0 0 : 190916/190920
162252 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 29192 0 0 0 0 0 0 : 191444/191392
165968 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 25108 0 0 0 0 0 0 : 191076/191036
168480 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 22316 0 0 0 0 0 0 : 190796/190768
173308 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 17428 0 0 0 0 0 0 : 190736/190640
177504 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 13784 0 0 0 0 0 0 : 191288/191240
179792 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12036 0 0 0 0 0 0 : 191828/191768
179976 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11920 0 0 0 0 0 0 : 191896/191836
179956 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11920 0 0 0 0 0 0 : 191876/191828
179996 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11900 0 0 0 0 0 0 : 191896/191836
180088 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 191992/191932
180084 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 191988/191928
180092 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 191996/191948
180108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192012/191952
180128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192032/191976
180112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192016/191968
180124 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192028/191972
180120 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192024/191964
180116 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192020/191960
180108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192012/191952
180116 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192020/191960
180112 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192016/191956
180116 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192020/191960
180108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 11904 0 0 0 0 0 0 : 192012/191964
182444 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9344 0 0 0 0 0 0 : 191788/191744
182436 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9344 0 0 0 0 0 0 : 191780/191736
182452 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9344 0 0 0 0 0 0 : 191796/191752
182412 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9340 0 0 0 0 0 0 : 191752/191712
182436 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9344 0 0 0 0 0 0 : 191780/191736
182620 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9352 0 0 0 0 0 0 : 191972/191940
182616 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9352 0 0 0 0 0 0 : 191968/191924
182600 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9352 0 0 0 0 0 0 : 191952/191920
182636 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9352 0 0 0 0 0 0 : 191988/191948

# dd if=/dev/zero of=/mnt/sdb1/zero bs=4096 count=$((1024*1024/4))

dm-0 ............................................. sda sdb ..........

107608 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9344 0 0 0 0 0 0 : 116952/191732
78824 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 7984 27644 0 0 0 0 0 : 114452/191544
77372 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6548 56972 0 0 0 0 0 : 140892/191400
81412 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 5392 80476 0 0 0 0 0 : 167280/191224
76444 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4252 104060 0 0 0 0 0 : 184756/191492
63408 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3412 121332 0 0 0 0 0 : 188152/191464
57868 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2976 130160 0 0 0 0 0 : 191004/191368
49324 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2520 139324 0 0 0 0 0 : 191168/191192
40516 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2072 148420 0 0 0 0 0 : 191008/191020
33748 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1724 156288 0 0 0 0 0 : 191760/191772
29280 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1496 160896 0 0 0 0 0 : 191672/191688
26288 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1344 163744 0 0 0 0 0 : 191376/191400
21440 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1096 168844 0 0 0 0 0 : 191380/191372
17796 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 908 172452 0 0 0 0 0 : 191156/191164
16004 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 816 174636 0 0 0 0 0 : 191456/191468
15048 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 768 175836 0 0 0 0 0 : 191652/191664
15052 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 768 175896 0 0 0 0 0 : 191716/191728
12904 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 660 178228 0 0 0 0 0 : 191792/191812
12880 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 656 178264 0 0 0 0 0 : 191800/191812
12884 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 656 178284 0 0 0 0 0 : 191824/191832
12900 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 656 178512 0 0 0 0 0 : 192068/192092
12900 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 656 178528 0 0 0 0 0 : 192084/192096
12900 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 656 178516 0 0 0 0 0 : 192072/192084
9256 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182184 0 0 0 0 0 : 191912/191892
9256 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182156 0 0 0 0 0 : 191884/191860
9256 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182180 0 0 0 0 0 : 191908/191888
9256 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182172 0 0 0 0 0 : 191900/191880
9260 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182192 0 0 0 0 0 : 191924/191900
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182352 0 0 0 0 0 : 192092/192080
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182384 0 0 0 0 0 : 192124/192100
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182372 0 0 0 0 0 : 192112/192100
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182380 0 0 0 0 0 : 192120/192096
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182364 0 0 0 0 0 : 192104/192092
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182396 0 0 0 0 0 : 192136/192112
9268 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 472 182392 0 0 0 0 0 : 192132/192108


--=-eHZsKawzd8v+IjsQw5HW
Content-Disposition: attachment; filename=wu-reiser.patch
Content-Type: application/mbox; name=wu-reiser.patch
Content-Transfer-Encoding: 7bit

>From wfg@mail.ustc.edu.cn Tue Oct 23 11:48:28 2007
Received: from pentafluge.infradead.org (pentafluge.infradead.org
	[213.146.154.40]) (using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168
	bits)) (No client certificate requested) by
	gateway.programming.kicks-ass.net (Postfix) with ESMTP id 5420413CA5F for
	<peter@programming.kicks-ass.net>; Tue, 23 Oct 2007 11:48:28 +0200 (CEST)
Received: from smtp.ustc.edu.cn ([202.38.64.16] helo=ustc.edu.cn) by
	pentafluge.infradead.org with smtp (Exim 4.63 #1 (Red Hat Linux)) id
	1IkEc4-0004P7-J7 for peterz@infradead.org; Tue, 23 Oct 2007 08:55:50 +0100
Received: (eyou send program); Tue, 23 Oct 2007 15:55:19 +0800
Message-ID: <393126119.26275@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Received: from unknown (HELO localhost) (211.86.144.46) by 202.38.64.8 with
	SMTP; Tue, 23 Oct 2007 15:55:19 +0800
Received: from wfg by localhost with local (Exim 4.67) (envelope-from
	<wfg@ustc.edu.cn>) id 1IkEba-0001sv-5B; Tue, 23 Oct 2007 15:55:14 +0800
Date: Tue, 23 Oct 2007 15:55:14 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] reiserfs: don't drop PG_dirty when releasing
	sub-page-sized dirty file
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <200710221258.11384.maximlevitsky@gmail.com> <393051953.24752@ustc.edu.cn>
	 <200710221421.21439.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710221421.21439.maximlevitsky@gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-Spam-Checker-Version: SpamAssassin 3.0.3-gr0 (2005-04-27) on server
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=5.0 tests=AWL,BAYES_00,
	MSGID_FROM_MTA_HEADER,RCVD_BY_IP,TW_FC,TW_JL autolearn=no  version=3.0.3-gr0
X-Evolution-Source:
	imap://peter%40programming.kicks-ass.net@programming.kicks-ass.net/
Content-Transfer-Encoding: 8bit

This is not a new problem in 2.6.23-git17.
2.6.22/2.6.23 is buggy in the same way.

Reiserfs could leave newly created sub-page-size files in dirty state
for ever.  They cannot be synced to disk by pdflush routines or
explicit `sync' commands.  Only `umount' can do the trick.

The direct cause is: the dirty page's PG_dirty is wrongly _cleared_.
Call trace:
	 [<ffffffff8027e920>] cancel_dirty_page+0xd0/0xf0
	 [<ffffffff8816d470>] :reiserfs:reiserfs_cut_from_item+0x660/0x710
	 [<ffffffff8816d791>] :reiserfs:reiserfs_do_truncate+0x271/0x530
	 [<ffffffff8815872d>] :reiserfs:reiserfs_truncate_file+0xfd/0x3b0
	 [<ffffffff8815d3d0>] :reiserfs:reiserfs_file_release+0x1e0/0x340
	 [<ffffffff802a187c>] __fput+0xcc/0x1b0
	 [<ffffffff802a1ba6>] fput+0x16/0x20
	 [<ffffffff8029e676>] filp_close+0x56/0x90
	 [<ffffffff8029fe0d>] sys_close+0xad/0x110
	 [<ffffffff8020c41e>] system_call+0x7e/0x83

Fix the bug by removing the cancel_dirty_page() call. Tests show that
it causes no bad behaviors on various write sizes.


=== for the patient ===
Here are more detailed demonstrations of the problem.

1) the page has both PG_dirty(D)/PAGECACHE_TAG_DIRTY(d) after being written to;
   and then only PAGECACHE_TAG_DIRTY(d) remains after the file is closed.

------------------------------ screen 0 ------------------------------
[T0] root /home/wfg# cat > /test/tiny
[T1] hi
[T2] root /home/wfg#

------------------------------ screen 1 ------------------------------
[T1] root /home/wfg# echo /test/tiny > /proc/filecache
[T1] root /home/wfg# cat /proc/filecache
     # file /test/tiny
     # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
     # idx   len     state   refcnt
     0       1       ___UD__Bd_      2
[T2] root /home/wfg# cat /proc/filecache
     # file /test/tiny
     # flags R:referenced A:active M:mmap U:uptodate D:dirty W:writeback O:owner B:buffer d:dirty w:writeback
     # idx   len     state   refcnt
     0       1       ___U___Bd_      2

2) note the non-zero 'cancelled_write_bytes' after /tmp/hi is copied.

------------------------------ screen 0 ------------------------------
[T0] root /home/wfg# echo hi > /tmp/hi
[T1] root /home/wfg# cp /tmp/hi /dev/stdin /test
[T2] hi
[T3] root /home/wfg#

------------------------------ screen 1 ------------------------------
[T1] root /proc/4397# cd /proc/`pidof cp`
[T1] root /proc/4713# cat io
     rchar: 8396
     wchar: 3
     syscr: 20
     syscw: 1
     read_bytes: 0
     write_bytes: 20480
     cancelled_write_bytes: 4096
[T2] root /proc/4713# cat io
     rchar: 8399
     wchar: 6
     syscr: 21
     syscw: 2
     read_bytes: 0
     write_bytes: 24576
     cancelled_write_bytes: 4096

//Question: the 'write_bytes' is a bit more than expected ;-)

Cc: Maxim Levitsky <maximlevitsky@gmail.com>                                                                           
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/reiserfs/stree.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-2.6.24-git17.orig/fs/reiserfs/stree.c
+++ linux-2.6.24-git17/fs/reiserfs/stree.c
@@ -1458,9 +1458,6 @@ static void unmap_buffers(struct page *p
 				}
 				bh = next;
 			} while (bh != head);
-			if (PAGE_SIZE == bh->b_size) {
-				cancel_dirty_page(page, PAGE_CACHE_SIZE);
-			}
 		}
 	}
 }


--=-eHZsKawzd8v+IjsQw5HW
Content-Disposition: attachment; filename=writeback-early.patch
Content-Type: text/x-patch; name=writeback-early.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Subject: mm: speed up writeback ramp-up on clean systems

We allow violation of bdi limits if there is a lot of room on the
system. Once we hit half the total limit we start enforcing bdi limits
and bdi ramp-up should happen. Doing it this way avoids many small
writeouts on an otherwise idle system and should also speed up the
ramp-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 
---
 mm/page-writeback.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c	2007-09-28 10:08:33.937415368 +0200
+++ linux-2.6/mm/page-writeback.c	2007-09-28 10:54:26.018247516 +0200
@@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long bdi_nr_reclaimable;
-	long bdi_nr_writeback;
+	long nr_reclaimable, bdi_nr_reclaimable;
+	long nr_writeback, bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
 	long bdi_thresh;
@@ -376,11 +376,26 @@ static void balance_dirty_pages(struct a
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
+
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK);
+
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 			break;
 
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 

--=-eHZsKawzd8v+IjsQw5HW
Content-Disposition: attachment; filename=bdi-task-dirty.patch
Content-Type: text/x-patch; name=bdi-task-dirty.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Subject: mm: bdi: tweak task dirty penalty

Penalizing heavy dirtiers with 1/8-th the total dirty limit might be rather
excessive on large memory machines. Use sqrt to scale it sub-linearly.

Update the comment while we're there.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page-writeback.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6-2/mm/page-writeback.c
===================================================================
--- linux-2.6-2.orig/mm/page-writeback.c
+++ linux-2.6-2/mm/page-writeback.c
@@ -213,17 +213,21 @@ static inline void task_dirties_fraction
 }
 
 /*
- * scale the dirty limit
+ * Task specific dirty limit:
  *
- * task specific dirty limit:
+ *   dirty -= 8 * sqrt(dirty) * p_{t}
  *
- *   dirty -= (dirty/8) * p_{t}
+ * Penalize tasks that dirty a lot of pages by lowering their dirty limit. This
+ * avoids infrequent dirtiers from getting stuck in this other guys dirty
+ * pages.
+ *
+ * Use a sub-linear function to scale the penalty, we only need a little room.
  */
 void task_dirty_limit(struct task_struct *tsk, long *pdirty)
 {
 	long numerator, denominator;
 	long dirty = *pdirty;
-	u64 inv = dirty >> 3;
+	u64 inv = 8*int_sqrt(dirty);
 
 	task_dirties_fraction(tsk, &numerator, &denominator);
 	inv *= numerator;

--=-eHZsKawzd8v+IjsQw5HW
Content-Disposition: attachment; filename=bdi-sysfs.patch
Content-Type: text/x-patch; name=bdi-sysfs.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Subject: mm: sysfs: expose the BDI object in sysfs

Provide a place in sysfs for the backing_dev_info object.
This allows us to see and set the various BDI specific variables.

In particular this properly exposes the read-ahead window for all
relevant users and /sys/block/<block>/queue/read_ahead_kb should be
deprecated.

With patient help from Kay Sievers and Greg KH

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/genhd.c               |    3 +
 fs/fuse/inode.c             |    3 -
 fs/nfs/client.c             |   24 +++++----
 fs/nfs/internal.h           |   10 ++--
 fs/nfs/super.c              |   10 ++--
 include/linux/backing-dev.h |   19 +++++++
 include/linux/writeback.h   |    3 +
 lib/percpu_counter.c        |    1 
 mm/backing-dev.c            |  109 ++++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |    2 
 10 files changed, 163 insertions(+), 21 deletions(-)

Index: linux-2.6-2/block/genhd.c
===================================================================
--- linux-2.6-2.orig/block/genhd.c
+++ linux-2.6-2/block/genhd.c
@@ -182,6 +182,8 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
+	bdi_register(&disk->queue->backing_dev_info, NULL,
+		"%s", disk->disk_name);
 }
 
 EXPORT_SYMBOL(add_disk);
@@ -190,6 +192,7 @@ EXPORT_SYMBOL(del_gendisk);	/* in partit
 void unlink_gendisk(struct gendisk *disk)
 {
 	blk_unregister_queue(disk);
+	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
 			      disk->minors);
 }
Index: linux-2.6-2/fs/fuse/inode.c
===================================================================
--- linux-2.6-2.orig/fs/fuse/inode.c
+++ linux-2.6-2/fs/fuse/inode.c
@@ -467,7 +467,8 @@ static struct fuse_conn *new_conn(void)
 		atomic_set(&fc->num_waiting, 0);
 		fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 		fc->bdi.unplug_io_fn = default_unplug_io_fn;
-		err = bdi_init(&fc->bdi);
+		err = bdi_init_fmt(&fc->bdi, NULL,
+				"fuse-%llu", (unsigned long long)fc->id);
 		if (err) {
 			kfree(fc);
 			fc = NULL;
Index: linux-2.6-2/fs/nfs/client.c
===================================================================
--- linux-2.6-2.orig/fs/nfs/client.c
+++ linux-2.6-2/fs/nfs/client.c
@@ -657,7 +657,8 @@ static void nfs_server_set_fsinfo(struct
 /*
  * Probe filesystem information, including the FSID on v2/v3
  */
-static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh, struct nfs_fattr *fattr)
+static int nfs_probe_fsinfo(struct nfs_server *server, struct nfs_fh *mntfh,
+		struct nfs_fattr *fattr, const char *dev_name)
 {
 	struct nfs_fsinfo fsinfo;
 	struct nfs_client *clp = server->nfs_client;
@@ -678,7 +679,8 @@ static int nfs_probe_fsinfo(struct nfs_s
 		goto out_error;
 
 	nfs_server_set_fsinfo(server, &fsinfo);
-	error = bdi_init(&server->backing_dev_info);
+	error = bdi_init_fmt(&server->backing_dev_info, NULL,
+			     "nfs-%s", dev_name);
 	if (error)
 		goto out_error;
 
@@ -772,7 +774,7 @@ void nfs_free_server(struct nfs_server *
  * - keyed on server and FSID
  */
 struct nfs_server *nfs_create_server(const struct nfs_parsed_mount_data *data,
-				     struct nfs_fh *mntfh)
+				     struct nfs_fh *mntfh, const char *dev_name)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr;
@@ -792,7 +794,7 @@ struct nfs_server *nfs_create_server(con
 	BUG_ON(!server->nfs_client->rpc_ops->file_inode_ops);
 
 	/* Probe the root fh to retrieve its FSID */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 	if (server->nfs_client->rpc_ops->version == 3) {
@@ -949,7 +951,7 @@ static int nfs4_init_server(struct nfs_s
  * - keyed on server and FSID
  */
 struct nfs_server *nfs4_create_server(const struct nfs_parsed_mount_data *data,
-				      struct nfs_fh *mntfh)
+				      struct nfs_fh *mntfh, const char *dev_name)
 {
 	struct nfs_fattr fattr;
 	struct nfs_server *server;
@@ -991,7 +993,7 @@ struct nfs_server *nfs4_create_server(co
 		(unsigned long long) server->fsid.minor);
 	dprintk("Mount FH: %d\n", mntfh->size);
 
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 
@@ -1021,7 +1023,8 @@ error:
  * Create an NFS4 referral server record
  */
 struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *data,
-					       struct nfs_fh *mntfh)
+					       struct nfs_fh *mntfh,
+					       const char *dev_name)
 {
 	struct nfs_client *parent_client;
 	struct nfs_server *server, *parent_server;
@@ -1066,7 +1069,7 @@ struct nfs_server *nfs4_create_referral_
 		goto error;
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, mntfh, &fattr);
+	error = nfs_probe_fsinfo(server, mntfh, &fattr, dev_name);
 	if (error < 0)
 		goto error;
 
@@ -1100,7 +1103,8 @@ error:
  */
 struct nfs_server *nfs_clone_server(struct nfs_server *source,
 				    struct nfs_fh *fh,
-				    struct nfs_fattr *fattr)
+				    struct nfs_fattr *fattr,
+				    const char *dev_name)
 {
 	struct nfs_server *server;
 	struct nfs_fattr fattr_fsinfo;
@@ -1128,7 +1132,7 @@ struct nfs_server *nfs_clone_server(stru
 		nfs_init_server_aclclient(server);
 
 	/* probe the filesystem info for this server filesystem */
-	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo);
+	error = nfs_probe_fsinfo(server, fh, &fattr_fsinfo, dev_name);
 	if (error < 0)
 		goto out_free_server;
 
Index: linux-2.6-2/include/linux/backing-dev.h
===================================================================
--- linux-2.6-2.orig/include/linux/backing-dev.h
+++ linux-2.6-2/include/linux/backing-dev.h
@@ -11,6 +11,8 @@
 #include <linux/percpu_counter.h>
 #include <linux/log2.h>
 #include <linux/proportions.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -48,11 +50,28 @@ struct backing_dev_info {
 
 	struct prop_local_percpu completions;
 	int dirty_exceeded;
+
+	struct device *dev;
 };
 
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...);
+void bdi_unregister(struct backing_dev_info *bdi);
+
+#define bdi_init_fmt(bdi, parent, fmt...)			\
+	({							\
+	 	int ret = bdi_init(bdi);			\
+	 	if (!ret) {					\
+	 		ret = 0; /* bdi_register(bdi, parent, ##fmt); */	\
+	 		if (ret)				\
+	 			bdi_destroy(bdi);		\
+	 	}						\
+	 	ret;						\
+	 })
+
 static inline void __add_bdi_stat(struct backing_dev_info *bdi,
 		enum bdi_stat_item item, s64 amount)
 {
Index: linux-2.6-2/include/linux/writeback.h
===================================================================
--- linux-2.6-2.orig/include/linux/writeback.h
+++ linux-2.6-2/include/linux/writeback.h
@@ -113,6 +113,9 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
+void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		 struct backing_dev_info *bdi);
+
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied);
Index: linux-2.6-2/mm/backing-dev.c
===================================================================
--- linux-2.6-2.orig/mm/backing-dev.c
+++ linux-2.6-2/mm/backing-dev.c
@@ -4,12 +4,119 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/writeback.h>
+#include <linux/device.h>
+
+
+static struct class *bdi_class;
+
+static ssize_t read_ahead_kb_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	char *end;
+
+	bdi->ra_pages = simple_strtoul(buf, &end, 10) >> (PAGE_SHIFT - 10);
+
+	return end - buf;
+}
+
+#define K(pages) ((pages) << (PAGE_SHIFT - 10))
+
+#define BDI_SHOW(name, expr)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *page)	\
+{									\
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);		\
+									\
+	return snprintf(page, PAGE_SIZE-1, "%lld\n", (long long)expr);	\
+}
+
+BDI_SHOW(read_ahead_kb, K(bdi->ra_pages))
+
+BDI_SHOW(reclaimable_kb, K(bdi_stat(bdi, BDI_RECLAIMABLE)))
+BDI_SHOW(writeback_kb, K(bdi_stat(bdi, BDI_WRITEBACK)))
+
+static inline unsigned long get_dirty(struct backing_dev_info *bdi, int i)
+{
+	unsigned long thresh[3];
+
+	get_dirty_limits(&thresh[0], &thresh[1], &thresh[2], bdi);
+
+	return thresh[i];
+}
+
+BDI_SHOW(dirty_kb, K(get_dirty(bdi, 1)))
+BDI_SHOW(bdi_dirty_kb, K(get_dirty(bdi, 2)))
+
+#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+
+static struct device_attribute bdi_dev_attrs[] = {
+	__ATTR_RW(read_ahead_kb),
+	__ATTR_RO(reclaimable_kb),
+	__ATTR_RO(writeback_kb),
+	__ATTR_RO(dirty_kb),
+	__ATTR_RO(bdi_dirty_kb),
+	__ATTR_NULL,
+};
+
+static __init int bdi_class_init(void)
+{
+	bdi_class = class_create(THIS_MODULE, "bdi");
+	bdi_class->dev_attrs = bdi_dev_attrs;
+	return 0;
+}
+
+__initcall(bdi_class_init);
+
+int bdi_register(struct backing_dev_info *bdi, struct device *parent,
+		const char *fmt, ...)
+{
+	char *name;
+	va_list args;
+	int ret = 0;
+	struct device *dev;
+
+	va_start(args, fmt);
+	name = kvasprintf(GFP_KERNEL, fmt, args);
+	va_end(args);
+
+	if (!name)
+		return -ENOMEM;
+
+	dev = device_create(bdi_class, parent, MKDEV(0,0), name);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto exit;
+	}
+
+	bdi->dev = dev;
+	dev_set_drvdata(bdi->dev, bdi);
+
+exit:
+	kfree(name);
+	return ret;
+}
+
+void bdi_unregister(struct backing_dev_info *bdi)
+{
+	if (bdi->dev) {
+		device_unregister(bdi->dev);
+		bdi->dev = NULL;
+	}
+}
+
+EXPORT_SYMBOL(bdi_register);
+EXPORT_SYMBOL(bdi_unregister);
 
 int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, j;
 	int err;
 
+	bdi->dev = NULL;
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
 		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
 		if (err)
@@ -33,6 +140,8 @@ void bdi_destroy(struct backing_dev_info
 {
 	int i;
 
+	bdi_unregister(bdi);
+
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
 
Index: linux-2.6-2/mm/page-writeback.c
===================================================================
--- linux-2.6-2.orig/mm/page-writeback.c
+++ linux-2.6-2/mm/page-writeback.c
@@ -295,7 +295,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
Index: linux-2.6-2/lib/percpu_counter.c
===================================================================
--- linux-2.6-2.orig/lib/percpu_counter.c
+++ linux-2.6-2/lib/percpu_counter.c
@@ -102,6 +102,7 @@ void percpu_counter_destroy(struct percp
 		return;
 
 	free_percpu(fbc->counters);
+	fbc->counters = NULL;
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
Index: linux-2.6-2/fs/nfs/internal.h
===================================================================
--- linux-2.6-2.orig/fs/nfs/internal.h
+++ linux-2.6-2/fs/nfs/internal.h
@@ -65,16 +65,18 @@ extern void nfs_put_client(struct nfs_cl
 extern struct nfs_client *nfs_find_client(const struct sockaddr_in *, int);
 extern struct nfs_server *nfs_create_server(
 					const struct nfs_parsed_mount_data *,
-					struct nfs_fh *);
+					struct nfs_fh *, const char *);
 extern struct nfs_server *nfs4_create_server(
 					const struct nfs_parsed_mount_data *,
-					struct nfs_fh *);
+					struct nfs_fh *, const char *);
 extern struct nfs_server *nfs4_create_referral_server(struct nfs_clone_mount *,
-						      struct nfs_fh *);
+						      struct nfs_fh *,
+						      const char *);
 extern void nfs_free_server(struct nfs_server *server);
 extern struct nfs_server *nfs_clone_server(struct nfs_server *,
 					   struct nfs_fh *,
-					   struct nfs_fattr *);
+					   struct nfs_fattr *,
+					   const char *);
 #ifdef CONFIG_PROC_FS
 extern int __init nfs_fs_proc_init(void);
 extern void nfs_fs_proc_exit(void);
Index: linux-2.6-2/fs/nfs/super.c
===================================================================
--- linux-2.6-2.orig/fs/nfs/super.c
+++ linux-2.6-2/fs/nfs/super.c
@@ -1359,7 +1359,7 @@ static int nfs_get_sb(struct file_system
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs_create_server(&data, &mntfh);
+	server = nfs_create_server(&data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1442,7 +1442,7 @@ static int nfs_xdev_get_sb(struct file_s
 	dprintk("--> nfs_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1702,7 +1702,7 @@ static int nfs4_get_sb(struct file_syste
 		goto out;
 
 	/* Get a volume representation */
-	server = nfs4_create_server(&data, &mntfh);
+	server = nfs4_create_server(&data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out;
@@ -1787,7 +1787,7 @@ static int nfs4_xdev_get_sb(struct file_
 	dprintk("--> nfs4_xdev_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr);
+	server = nfs_clone_server(NFS_SB(data->sb), data->fh, data->fattr, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;
@@ -1861,7 +1861,7 @@ static int nfs4_referral_get_sb(struct f
 	dprintk("--> nfs4_referral_get_sb()\n");
 
 	/* create a new volume representation */
-	server = nfs4_create_referral_server(data, &mntfh);
+	server = nfs4_create_referral_server(data, &mntfh, dev_name);
 	if (IS_ERR(server)) {
 		error = PTR_ERR(server);
 		goto out_err_noserver;

--=-eHZsKawzd8v+IjsQw5HW--

