Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbXGaOW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbXGaOW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbXGaOWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:22:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29928 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbXGaOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:22:13 -0400
Message-ID: <46AF450D.5020106@oracle.com>
Date: Tue, 31 Jul 2007 10:19:57 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture, Linux Projects Group
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       kzak@redhat.com, sfrench@samba.org, trond.myklebust@fys.uio.no,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu> <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu>
Content-Type: multipart/mixed;
 boundary="------------060007020408060201090102"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060007020408060201090102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Miklos Szeredi wrote:
>> After a successful mount, the NFS mount command tucks some options into 
>> /etc/mtab that reflect which mountd was used for the mount, and what 
>> protocol version and port was used for the mount request.  Those options 
>> are not passed to the kernel, and do not appear in /proc/mounts today. 
>> See nfs(5)'s discussion of the mountport, mounthost, mountprog, and 
>> mountvers options.
>>
>> However, the trend for NFS is to push mount option parsing into the 
>> kernel.  Thus all options will be passed to the kernel, and at that 
>> point it should be able to reflect the mount* options in /proc/mounts. 
>> But it doesn't do that quite yet.
> 
> Trond, do you have a roadmap for this?

Well I'm actually doing the coding, and Trond is playing more of an 
architectural role.

We have a first implementation of in-kernel mount option parsing in 
2.6.23-rc now.  I'm currently working on the user-space piece of this. 
(And actually, now is a great time to review the new kernel part, while 
it is still quite young.)

However, the NFS mount user-space pieces have undergone radical change 
recently.  The mount.nfs helper was split from the mount command just 
last year, and is only now starting to go into distributions.  This is 
very old code that has been hacked on for over a decade, so it is taking 
a little while to rediscover its history and modernize it before we move 
forward.

I expect that both the kernel part and the user-space part will evolve 
together over the next few months as we clarify the full set of 
requirements.  The requirements for this effort now include:

+ making new mount options simple to implement;

+ removing ABI dependencies between mount.nfs and the kernel NFS client;

+ an eventual merge of the nfs and nfs4 file system types;

+ improved error handling and reporting during the mount process;

+ support for NFS over IPv6.

I think there is also some talk about fully supporting SELinux as well, 
but I haven't been following that closely.

The removal of /etc/mtab in favor of /proc/mounts is a new requirement, 
and is not as trivial as you might hope.  Internally the NFS client 
represents the mount options as a binary data structure, and it contains 
only the information that has traditionally been passed into the kernel 
by the current mount command.  The user-space-only options are not 
passed to the kernel nor stored in the data structure.

Adding facilities to store information about every possible mount 
option, including the user-space-only ones, will take a bit of time, but 
is possible, if not straightforward.  We just have to understand all the 
dependencies.

--------------060007020408060201090102
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
url:http://oss.oracle.com/~cel
version:2.1
end:vcard


--------------060007020408060201090102--
