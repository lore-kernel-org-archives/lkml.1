Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZECGZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZECGZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 02:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZECGZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 02:25:35 -0400
Received: from mail.lang.hm ([64.81.33.126]:60696 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZECGZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 02:25:34 -0400
Date: Sat, 2 May 2009 23:24:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Neil Brown <neilb@suse.de>
cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
In-Reply-To: <18941.12645.590037.589600@notabene.brown>
Message-ID: <alpine.DEB.1.10.0905022256230.15782@asgard>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <18941.12645.590037.589600@notabene.brown>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not a DRDB developer, but I can answer some of your questions below.

On Sun, 3 May 2009, Neil Brown wrote:

> On Thursday April 30, philipp.reisner@linbit.com wrote:
>> Hi,
>>
>> This is a repost of DRBD, to keep you updated about the ongoing
>> cleanups and improvements.
>>
>> Patch set attached. Git tree available:
>> git pull git://git.drbd.org/linux-2.6-drbd.git drbd
>>
>> We are looking for reviews!
>>
>> Description
>>
>>   DRBD is a shared-nothing, synchronously replicated block device. It
>>   is designed to serve as a building block for high availability
>>   clusters and in this context, is a "drop-in" replacement for shared
>>   storage. Simplistically, you could see it as a network RAID 1.
>
> I know this is minor, but it bugs me every time I see that phrase
> "shared-nothing".   Surely the network is shared??

the logical network(s) as a whole are shared, but physicaly they can be 
redundant, multi-pathed, etc.

> And the code...
> Can you just say "DRBD is a synchronously replicated block device"?
> or would we have to call it SRBD then?
> Or maybe "shared-nothing" is an accepted technical term in the
> clustering world??

DRDB can be configured to be synchronous or asynchronous.

'shared-nothing' is a accepted technical term in the clustering world for 
when two systems are not using any single device.

in the case of a network, I commonly setup systems where the network has 
two switches (connected togeather with fiber so that an electrical problem 
in one switch cannot short out the other) with the primary box plugged 
into one switch and the backup box plugged into another. I also make sure 
that my systems primary and backup systems are in seperate racks, so that 
if something goes wrong in one rack that causes an excessive amount of 
heat it won't affect the backup systems (and yes, this has happened to me 
when I got lazy and stopped checking on this)

at this point the network switch is not shared (although the logical 
network is)

in the case of disk storage the common situation is 'shared-disk' where 
you have one disk array and both machines are plugged into it.

this gives you a single point of failure if the disk array crashes (even 
if it has redundant controllers, power supplies, etc things still happen), 
and the disk array can only be in one physical location.

DRDB lets you logicly setup your systems as if they were a 'shared-disk' 
architecture, but with the hardware being 'shared-nothing'

you can have the two halves of the cluster in different states, so that 
even a major disaster like a earthquake won't kill the system. (a classic 
case of 'shared-nothing'

>>
>>    1) Think of a two node HA cluster. Node A is active ('primary' in DRBD
>>     speak) has the filesystem mounted and the application running. Node B is
>>     in standby mode ('secondary' in DRBD speak).
>
> If there some strong technical reason to only allow 2 nodes?  Was it
> Asimov who said the only sensible numbers were 0, 1, and infinity?
> (People still get surprised that md/raid1 can do 2 or 3 or n drives,
> and that md/raid5 can handle just 2 :-)

in this case we have 1 replica (or '1 other machine'), so we are on an 
'interesting number' ;-)

many people would love to see DRDB extended beyond this, but my 
understanding is that doing so in non-trivial.

>>   DRBD can also be used in dual-Primary mode (device writable on both
>>   nodes), which means it can exhibit shared disk semantics in a
>>   shared-nothing cluster.  Needless to say, on top of dual-Primary
>>   DRBD utilizing a cluster file system is necessary to maintain for
>>   cache coherency.
>>
>>   More background on this can be found in this paper:
>>     http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
>>
>>   Beyond that, DRBD addresses various issues of cluster partitioning,
>>   which the MD/NBD stack, to the best of our knowledge, does not
>>   solve. The above-mentioned paper goes into some detail about that as
>>   well.
>
> Agreed - MD/NBD could probably be easily confused by cluster
> partitioning, though I suspect that in many simple cases it would get
> it right.  I haven't given it enough thought to be sure.  I doubt the
> enhancements necessary would be very significant though.

think of two different threads doing writes directly to their side of the 
mirror and the system needs to notice this happening and copy the data to 
the other half of the mirror (with GFS working above you to coordinate the 
two threads and make sure they don't make conflicting writes)

it's not a trivial task.

David Lang
