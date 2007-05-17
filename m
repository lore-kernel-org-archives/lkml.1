Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbXEQRuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbXEQRuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbXEQRtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:49:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:29579 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759572AbXEQRto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ulImkBXLyuS1cEFltpQGg1Re/JXuOKUhuV90QJh3o9E3rmxj+zODOcS0VgdQoiA0heBNmwUc6hj2e+ALruZUCcSvlYPpE6RefrkDxy036zBN+phiSaFiV1EhT9gXOWqaEK7LwKC/+M+GfzPihXuP2+plZw9acNcu1SbUBkdfAec=
Message-ID: <464C95AB.3020209@gmail.com>
Date: Thu, 17 May 2007 19:49:31 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH -stable] sysfs: disable reclamation by default
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org> <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com>
In-Reply-To: <20070517173912.GA14370@in.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maneesh Soni wrote:
> On Thu, May 17, 2007 at 05:04:23AM -0700, Greg KH wrote:
>> On Wed, May 16, 2007 at 08:31:00PM +0200, Tejun Heo wrote:
>>> sd->s_dentry updates made by dentry/inode reclamation are racy and can
>>> lead to BUG() or oops.  This is already fixed in -mm and the fix is
>>> scheduled to be merged into upstream for 2.6.23 but the fix
>>> reimplements sysfs dentry dropping and is too risky for -stable
>>> kernels.
>>>
> 
> But was the synchronization fix tested by people facing the race? I still
> don't understand the racy code path. The last google problem I saw had
> s_dentry field as NULL.

Please take a look at the following message.

  http://article.gmane.org/gmane.linux.kernel/521729

I could reproduce both races on my test machine fairly reliable with
parallel find, cat, mount/mount while repeatedly ins/rmmoding a libata
driver.

>>> This is an interim solution for -stable kernels.  sysfs reclamation is
>>> disabled by default and can be enabled by using sysfs.enable_reclaim
>>> kernel parameter.  Note that dentries are still created on demand, so
>>> attribute and symlinks nodes aren't allocated on creation.  They're
>>> allocated on first lookup and deallocated when the sysfs node is
>>> removed.
>> Ick, this is going to kill memory on big boxes (s390 and others) and I
>> don't really want to apply this it if at all possible.
>>
> At least not make it default. This might create boot issues with these
> boxes. 

Which makes oopsing the default.  Fun!  :-)

>> Maneesh, any other thoughts?
>>
> I actually wanted to investigate this oops but left it considering the
> rework being done by Tejun. If this still make sense we can have some
> more debug code stuffed there or get a crashdump (kdump) to get better
> understanding of the race.

The above message contains analysis of both races.  I just ported the
fixes.  I have a different test machine now and can't reproduce the
races with this one yet so I couldn't verify whether the patches
actually fix the problem.  I'll post the patches anyway.  If anyone can
reproduce these races, please verify the posted patches fix the problem.

Thanks.

-- 
tejun
