Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbXFJRJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbXFJRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXFJRJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:09:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47314 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbXFJRJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:09:48 -0400
Message-ID: <466C303E.5010304@novell.com>
Date: Sun, 10 Jun 2007 10:09:18 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: Greg KH <greg@kroah.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       Pavel Machek <pavel@ucw.cz>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> 200706091705.57082.agruen@suse.de
In-Reply-To: <20070609001703.GA17644@kroah.com> 200706091705.57082.agruen@suse.de
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Gruenbacher wrote:
> On Saturday 09 June 2007 02:17, Greg KH wrote:
>   
>> On Sat, Jun 09, 2007 at 12:03:57AM +0200, Andreas Gruenbacher wrote:
>>     
>>> AppArmor is meant to be relatively easy to understand, manage, and
>>>  customize, and introducing a labels layer wouldn't help these goals.
>>>       
>> Woah, that describes the userspace side of AA just fine, it means
>> nothing when it comes to the in-kernel implementation. There is no 
>> reason that you can't implement the same functionality using some
>> totally different in-kernel solution if possible.
>>     
> I agree that the in-kernel implementation could use different abstractions 
> than user-space, provided that the underlying implementation details can be 
> hidden well enough. The key phrase here is "if possible", and in fact "if 
> possible" is much too strong: very many things in software are possible, 
> including user-space drives and a stable kernel module ABI. Some things make 
> sense; others are genuinely bad ideas while still possible.
>   
In particular, to layer AppArmor on top of SELinux, the following
problems must be addressed:

    * New files: when a file is created, it is labeled according to the
      type of the creating process and the type of the parent directory.
      Applications can also use libselinux to use application logic to
      relabel the file, but that is not 'mandatory' policy, and fails in
      cases like cp and mv. AppArmor lets you create a policy that e..g
      says "/home/*/.plan r" to permit fingerd to read everyone's .plan
      file, should it ever exist, and you cannot emulate that with SELinux.
    * Renamed Files: Renaming a file changes the policy with respect to
      that file in AA. To emulate this in SELinux, you would have to
      have a way to instantly re-label the file upon rename.
    * Renamed Directory trees: The above problem is compounded with
      directory trees. Changing the name at the top of a large, bushy
      tree can require instant relabeling of millions of files.
    * New Policies: The SEEdit approach of compiling AA profiles into
      SELinux labels involves computing the partition set of files, so
      that each element of the partition set is unique, and corresponds
      to all the policies that treat every file in the element
      identically. If you create a new profile that touches *some* of
      the files in such an element, then you have to split that
      synthetic label, re-compute the partition set, and re-label the
      file system.
    * File Systems That Do Not Support Labels: The most important being
      NFS3 and FAT. Because they do not support labels at all, SELinux
      has to give you an all-or-nothing access control on the entire
      remote volume. AA can give you nuanced access control in these
      file systems.

You could support all of these features in SELinux, but only by adding
an in-kernel file matching mechanism similar to AppArmor. It would
basically load an AppArmor policy into the kernel, label files as they
are brought from disk into the cache, and then use SELinux to do the
access controls.

That doesn't make it a good idea:

    * The patch would be at least as complex and intrusive as the
      proposed AppArmor patch, there is no simplicity already-upstream
      savings here.
    * It would require the VFS and d_path patches that AppArmor needs to
      pass mount points down.
    * It would make AppArmor's ability to change policies on a live
      system more difficult.
    * The necessary extensions would not be appealing to the SELinux
      community.

LSM is the common code that AA and SELinux have agreed to be mutually
useful. Forcing AA to sit on top of SELinux would harm both AA and SELinux.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

