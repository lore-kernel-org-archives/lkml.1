Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081AbXFORSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbXFORSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXFORRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:17:50 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63963 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXFORRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:17:48 -0400
Message-ID: <4672C992.6000301@oracle.com>
Date: Fri, 15 Jun 2007 13:17:06 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
References: <20070612161029.GB28279@think.oraclecorp.com> <18031.26764.586958.632146@stoffel.org> <467186EA.6090409@oracle.com> <20070614184851.GD2061@think.oraclecorp.com>
In-Reply-To: <20070614184851.GD2061@think.oraclecorp.com>
Content-Type: multipart/mixed;
 boundary="------------050908030402010208020003"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050908030402010208020003
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Chris Mason wrote:
> On Thu, Jun 14, 2007 at 02:20:26PM -0400, Chuck Lever wrote:
>> NetApp happens to use the standard NDMP protocol for sending the 
>> flattened file system.  NetApp uses it for synchronous replication, 
>> volume migration, and back up to nearline storage and tape.  AFS used 
>> "vol dump" and "vol restore" for migration, replication, and back-up. 
>> ZFS has the "zfs send" and "zfs receive" commands that do basically the 
>> same (Eric Kustarz recently published a blog entry that described how 
>> these work).  And of course, all file system objects are able to be sent 
>> this way:  streams, xattrs, ACLs, and so on are all supported.
>>
>> Note also that NFSv4 supports the idea of migrated or replicated file 
>> objects.  All that is needed to support it is a mechanism on the servers 
>> to actually move the data.
> 
> Stringing the replication together with the underlying FS would be neat.
> Is there a way to deal with a master/slave setup, where the slave may be
> out of date?

Among the implementations I'm aware of, there is a varying degree of 
integration into the physical file system.  In general, it depends on 
how far out of date the slave is, and how closely the slave is supposed 
to be synchronized to the master.

A hot backup file system, for example, should be data-consistent within 
a few seconds of the master.  A snapshot is used to initialize a slave, 
followed by a live stream of updates to the master being sent to slaves. 
  Such a mechanism already exists on NetApp filers because they gather 
changes in NVRAM before committing them to the local file system. 
Simply put, these changes can also be bundled and sent to a local hot 
backup filer that is attached via Infiniband, or over the network to a 
remote hot backup filer.

For AFS, replication is done by maintaining a rw and ro copy of a volume 
on the designated master server.  Changes are made to the rw copy over 
time.  When admins want to push out a new version to replicas on another 
server, the ro copy on the master is replaced with a new snapshot, then 
this is pushed to the slaves.  The replicas are always ro and are used 
mostly for load balancing; clients contact the closest or fastest server 
containing a replica of the volume they want to access.  They always 
have a complete copy of the volume (ie no COW on the slaves).

I think you have designed into btrfs a lot of opportunity to implement 
this kind of data virtualization and management... I'm excited to see 
what can be done.

--------------050908030402010208020003
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel/
version:2.1
end:vcard


--------------050908030402010208020003--
