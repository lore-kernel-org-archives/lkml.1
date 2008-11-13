Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYKMOe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYKMOe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYKMOes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:34:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYKMOer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:34:47 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua>
	<20081110104423.GA26778@kernel.dk>
	<x493ahzsn8p.fsf@segfault.boston.devel.redhat.com>
	<20081110135618.GI26778@kernel.dk>
	<x491vxgkd61.fsf@segfault.boston.devel.redhat.com>
	<491BCF0D.8050502@telenet.dn.ua>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 13 Nov 2008 09:32:27 -0500
In-Reply-To: <491BCF0D.8050502@telenet.dn.ua> (Vitaly V. Bursov's message of
	"Thu, 13 Nov 2008 08:54:05 +0200")
Message-ID: <x49skpvg0hw.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Vitaly V. Bursov" <vitalyb@telenet.dn.ua> writes:

> Jeff Moyer пишет:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> 
>>> On Mon, Nov 10 2008, Jeff Moyer wrote:
>>>> Jens Axboe <jens.axboe@oracle.com> writes:
>>>>
>>>>> On Sun, Nov 09 2008, Vitaly V. Bursov wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I'm building small server system with openvz kernel and have ran into
>>>>>> some IO performance problems. Reading a single file via NFS delivers
>>>>>> around 9 MB/s over gigabit network, but while reading, say, 2 different
>>>>>> or same file 2 times at the same time I get >60MB/s.
>>>>>>
>>>>>> Changing IO scheduler to deadline or anticipatory fixes problem.
>>>>>>
>>>>>> Tested kernels:
>>>>>>   OpenVZ RHEL5 028stab059.3 (9 MB/s with HZ=100, 20MB/s with HZ=1000
>>>>>>                  fast local reads)
>>>>>>   Vanilla 2.6.27.5 (40 MB/s with HZ=100, slow local reads)
>>>>>>
>>>>>> Vanilla performs better in worst case but I believe 40 is still low
>>>>>> concerning test results below.
>>>>> Can you check with this patch applied?
>>>>>
>>>>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
>>>> Funny, I was going to ask the same question.  ;)  The reason Jens wants
>>>> you to try this patch is that nfsd may be farming off the I/O requests
>>>> to different threads which are then performing interleaved I/O.  The
>>>> above patch tries to detect this and allow cooperating processes to get
>>>> disk time instead of waiting for the idle timeout.
>>> Precisely :-)
>>>
>>> The only reason I haven't merged it yet is because of worry of extra
>>> cost, but I'll throw some SSD love at it and see how it turns out.
>> 
>> OK, I'm not actually able to reproduce the horrible 9MB/s reported by
>> Vitaly.  Here are the numbers I see.
>
> It's 2.6.18-openvz-rhel5 kernel gives me 9MB/s, and with 2.6.27 I get ~40-50MB/s
> instead of 80-90 MB/s as there should be no bottlenecks except the network.

Reading back through your original problem report, I'm not seeing what
your numbers were with deadline; you simply mentioned that it "fixed"
the problem.  Are you sure you'll get 80-90MB/s for this?  The local
disks in my configuration, when performing a dd on the server system,
can produce numbers around 85 MB/s, yet the NFS performance is around 65
MB/s (and this is a gigabit network).

>> Single dd performing a cold cache read of a 1GB file from an
>> nfs server.  read_ahead_kb is 128 (the default) for all tests.
>> cfq-cc denotes that the cfq scheduler was patched with the close
>> cooperator patch.  All numbers are in MB/s.
>> 
>> nfsd threads|   1  |  2   |  4   |  8  
>> ----------------------------------------
>> deadline    | 65.3 | 52.2 | 46.7 | 46.1
>> cfq         | 64.1 | 57.8 | 53.3 | 46.9
>> cfq-cc      | 65.7 | 55.8 | 52.1 | 40.3
>> 
>> So, in my configuration, cfq and deadline both degrade in performance as
>> the number of nfsd threads is increased.  The close cooperator patch
>> seems to hurt a bit more at 8 threads, instead of helping;  I'm not sure
>> why that is.
>
> Interesting, I'll try to change nfsd threads number and see how it performs
> on my setup. Setting it to 1 seems like a good idea for cfq and a non-high-end
> hardware.

I think you're looking at this backwards.  I'm no nfsd tuning expert,
but I'm pretty sure that you would tune the numbe,r of threads based on
the number of active clients and the amount of memory on the server
(since each thread has to reserve memory for incoming requests).

> I'll look into it this evening.

The real reason I tried varying the number of nfsd threads was to show,
at least for CFQ, that spreading a sequential I/O load across multiple
threads would result in suboptimal performance.  What I found, instead,
was that it hurt performance for cfq *and* deadline (and that the close
cooperator patches did not help in this regard).  This tells me that
there is something else which is affecting the performance.  What that
something is I don't know, I think we'd have to take a closer look at
what's going on on the server to figure it out.

Cheers,

Jeff
