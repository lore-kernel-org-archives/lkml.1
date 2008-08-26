Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYHZA7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYHZA7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 20:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYHZA7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 20:59:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:11517 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbYHZA7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 20:59:39 -0400
X-IronPort-AV: E=Sophos;i="4.32,266,1217833200"; 
   d="scan'208";a="39134555"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: NFS regression? Odd delays and lockups accessing an NFS export.
Date: Mon, 25 Aug 2008 17:59:34 -0700
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC9E0289@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <kgh6b498u1t11gur76aefbs878grh5gal7@4ax.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: NFS regression? Odd delays and lockups accessing an NFS export.
Thread-Index: AckHEu0EcOC0GN+gQfiSFSfvF1yyJwAA/qBQ
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Grant Coady" <gcoady.lk@gmail.com>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: "Ian Campbell" <ijc@hellion.org.uk>,
       "John Ronciak" <john.ronciak@gmail.com>, <linux-kernel@vger.kernel.org>,
       <neilb@suse.de>, <bfields@fieldses.org>, <linux-nfs@vger.kernel.org>,
       "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
       "Bruce Allan" <bruce.w.allan@intel.com>,
       "PJ Waskiewicz" <peter.p.waskiewicz.jr@intel.com>,
       "John Ronciak" <john.ronciak@intel.com>,
       <e1000-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 26 Aug 2008 00:59:37.0594 (UTC) FILETIME=[0330C5A0:01C90717]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try '-s 0', from tcpdump(8): "Setting snaplen to 0 means use the
required length to catch whole packets."

  -Dan

-----Original Message-----
From: Grant Coady [mailto:grant_lkml@dodo.com.au] 
Sent: Monday, August 25, 2008 5:29 PM
To: Trond Myklebust
Cc: Grant Coady; Ian Campbell; John Ronciak;
linux-kernel@vger.kernel.org; neilb@suse.de; bfields@fieldses.org;
linux-nfs@vger.kernel.org; Jeff Kirsher; Jesse Brandeburg; Bruce Allan;
PJ Waskiewicz; John Ronciak; e1000-devel@lists.sourceforge.net
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS
export.

On Mon, 25 Aug 2008 18:11:12 -0400, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:

>On Tue, 2008-08-26 at 06:23 +1000, Grant Coady wrote:
>> On Fri, 22 Aug 2008 14:56:53 -0700, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
>> 
>> >On Fri, 2008-08-22 at 22:37 +0100, Ian Campbell wrote:
>> >> I can ssh to the server fine. The same server also serves my NFS 
>> >> home directory to the box I'm writing this from and I've not seen 
>> >> any trouble with this box at all, it's a 2.6.18-xen box.
>> >
>> >OK... Are you able to reproduce the problem reliably?
>> >
>> >If so, can you provide me with a binary tcpdump or wireshark dump? 
>> >If using tcpdump, then please use something like
>> >
>> >   tcpdump -w /tmp/dump.out -s 90000 host myserver.foo.bar and port 
>> > 2049
>>                              ^^^^^^^^-->  typo?
>
>No. The intention was to record _all_ the info in the packet for 
>analysis, not just random header info.

Hi Trond,

My tcpdump seems to have a 16 bit snaplen counter:

~# tcpdump -w /tmp/dump.out -s 65535 host deltree and port 2049
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size
65535 bytes ^C0 packets captured
4 packets received by filter
0 packets dropped by kernel

~# tcpdump -w /tmp/dump.out -s 65536 host deltree and port 2049
tcpdump: invalid snaplen 65536

~# tcpdump --version
tcpdump version 3.9.8
libpcap version 0.9.8


So I'm now using:
~# tcpdump -w /tmp/dump.out -s 65535 -C 10 -W 100 host deltree and port
2049
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size
65535 bytes

to get a 1GB round-robin trace buffer, I can stop the trace when problem
noticed, as it is so long between delay/stall happenings.  Then I'll try
to trigger the thing.

Is this the correct style of trace you are expecting?

~$ /usr/sbin/tcpdump -r /tmp/dump.out00
reading from file /tmp/dump.out00, link-type EN10MB (Ethernet)
10:13:49.719781 IP pooh64.mire.mine.nu.2156510591 >
deltree.mire.mine.nu.nfs: 116 access fh 0,1/218104576 001f
10:13:49.720215 IP deltree.mire.mine.nu.nfs >
pooh64.mire.mine.nu.2156510591: reply ok 124 access c 001f
10:13:49.720225 IP pooh64.mire.mine.nu.984 > deltree.mire.mine.nu.nfsd:
. ack 1649405551 win 5840
10:13:49.720288 IP pooh64.mire.mine.nu.2173287807 >
deltree.mire.mine.nu.nfs: 136 readdirplus fh 0,1/218104576 512 bytes @ 0
10:13:49.742450 IP deltree.mire.mine.nu.nfs >
pooh64.mire.mine.nu.2173287807: reply ok 1460 readdirplus


Is there some test suite I can use?  Compiling kernels over NFS worked
fine yesterday, apart from the fastest box' make complaining about clock
skew.  The kernel booted though, so that was okay.  

Guess it's back to the interactive editing over NFS and see if the thing
manifest the delay/stalls again, I'm on the .27-rc4-git4 kernel as soon
as it compiles for the client, NFS server is 2.6.24.7 at the moment.

Grant.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
