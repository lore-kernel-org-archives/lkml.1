Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYIQPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYIQPlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 11:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYIQPlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 11:41:19 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:48943 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYIQPlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 11:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RVLcwdiq4tkuLVJUFyhPq9DzpE9jP0gljQwGSccqtvKBylpk55XXWRwCXUyFDw68ii
         uVuXhDt7YqypULhe3KDHv1w5ix23YzwiKEQtDm46oYxwVz2qw7lFwzDzBkDZUdhZLf7+
         Afq83X1RD7OgacUUcSfrvQiaAJLZUpfFDCtCk=
Message-ID: <76bd70e30809170841x1324ad78xab90982f1a08b741@mail.gmail.com>
Date: Wed, 17 Sep 2008 10:41:15 -0500
From: "Chuck Lever" <chucklever@gmail.com>
To: "Peter Staubach" <staubach@redhat.com>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
Cc: "Martin Knoblauch" <knobi@knobisoft.de>,
       "linux-nfs list" <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48D10EF4.6050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <997439.5560.qm@web32601.mail.mud.yahoo.com>
	 <48D10EF4.6050808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 9:06 AM, Peter Staubach <staubach@redhat.com> wrote:
> Martin Knoblauch wrote:
>>
>> Hi,
>>
>> the following/attached patch works around a [obscure] problem when an 2.6
>> (not sure/caring about 2.4) NFS client accesses an "offline" file on a
>> Sun/Solaris-10 NFS server when the underlying filesystem is of type SAM-FS.
>> Happens with RHEL4/5 and mainline kernels. Frankly, it is not a Linux
>> problem, but the chance for a short-/mid-term solution from Sun are very
>> slim. So, being lazy, I would love to get this patch into Linux. If not, I
>> just will have to maintain it for eternity out of tree.
>>
>> The problem: SAM-FS is Suns proprietary HSM filesystem. It stores
>> meta-data and a relatively small amount of data "online" on disk and pushes
>> old or infrequently used data to "offline" media like e.g. tape. This is
>> completely transparent to the users. If the date for an "offline" file is
>> needed, the so called "stager daemon" copies it back from the offline
>> medium. All of this works great most of the time. Now, if an Linux NFS
>> client tries to read such an offline file, performance drops to "extremely
>> slow". After lengthly investigation of tcp-dumps, mount options and
>> procedures involving black cats at midnight, we found out that the readahead
>> behaviour of the Linux NFS client causes the problem. Basically it seems to
>> issue read requests up to 15*rsize to the server. In the case of the
>> "offline" files, this behaviour causes heavy competition for the inode lock
>> between the NFSD process and the stager daemon on the Solaris server.
>>
>> - The real solution: fixing SAM-FS/NFSD interaction. Sun engineering acks
>> the problem, but a solution will need time. Lots of it.
>> - The working solution: disable the client side readahead, or make it
>> tunable. The patch does that by introducing a NFS module parameter
>> "ra_factor" which can take values between 1 and 15 (default 15) and a
>> tunable "/proc/sys/fs/nfs/nfs_ra_factor" with the same range and default.
>
> Hi.
>
> I was curious if a design to limit or eliminate read-ahead
> activity when the server returns EJUKEBOX was considered?
> Unless one can know that the server and client can get into
> this situation ahead of time, how would the tunable be used?

I tend to agree.  A tunable is probably not a good solution in this case.

I would bet that this lock contention issue is a problem in other more
common cases, and would merit some careful analysis.

-- 
Chuck Lever
