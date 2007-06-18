Return-Path: <linux-kernel-owner+w=401wt.eu-S1765457AbXFRSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765457AbXFRSt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762569AbXFRStR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:49:17 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54411 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761796AbXFRStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:49:15 -0400
Message-ID: <4676D399.1010603@novell.com>
Date: Mon, 18 Jun 2007 11:48:57 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pavel Machek <pavel@ucw.cz>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com>
In-Reply-To: <20070615234925.GB15056@kroah.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jun 15, 2007 at 04:30:44PM -0700, Crispin Cowan wrote:
>   
>> Then there's all the other problems, such as file systems that don't
>> support extended attributes, particularly NFS3. Yes, NFS3 is vulnerable
>> to network attack, but that is not the threat AA is addressing. AA is
>> preventing an application with access to an NFS mount from accessing the
>> *entire* mount. There is lots of practical security value in this, and
>> label schemes cannot do it. Well, mostly; you could do it with a dynamic
>> labeling scheme that labels files as they are pulled into kernel memory,
>> but that requires an AA-style regexp parser in the kernel to apply the
>> labels.
>>     
> You still haven't answered Stephen's response to NFSv3, so until then,
> please don't trot out this horse.
>   
Ok then ...

Stephen Smalley wrote:
> - File systems that do not support labels:  I'm a bit surprised that you
> would advocate this given your experience in developing EA and ACL
> support for local filesystems and NFS.  The pathname-based approach in
> NFS seems even scarier than in the local case - the clients may have
> different views of the namespace than one another or the server and the
> potential for inconsistent views of the tree (particularly as it is
> being modified) during access checks is only greater in the NFS case,
> right?  It may be more expedient to implement, but is it the right
> technical approach?
I'm actually unclear on what the question is. Stephen appears to be
thinking of confining the NFS server daemon, and our intended use case
is to use AppArmor to confine applications that access data on NFS clients.

    * Each NFS *client* machine has a view of the NFS mount point that
      is consistent for that client.
    * The AA confinement is of the application accessing the NFS mount
      on the client, *not* the NFS server daemon.
    * The fact that the views of multiple clients are different from
      each other is irrelevant, because we are confining applications on
      the client, not the NFS server daemon.
    * As noted in Andreas' technical document
      http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/techdoc.pdf
      there is no purpose to confining the NFS server daemon; it is a
      kernel process, and if it mis-behaves, it can completely subvert
      any kernel security policy, including AA and SELinux.

Since this point seems to be subtle, here's a motivating example.
Consider I have a diskless workstation, and my home dir /home/crispin is
NFS mounted from a big NAS server over there. I like to run my FireFox
confined, so that it only has access to /home/crispin/.mozilla/** and
/home/crispin/Downloads/** so that if my browser is compromised, the
attacker doesn't get to my /home/.ssh* stuff.

Yes, the data served over NFS is vulnerable to a local network attack,
but that is not what AA is preventing here. The threat is coming from
attacks that make the web browser misbehave.

Under SELinux, I either give the web browser access to all of
/home/crispin (the entire mount point) or none of it. Under AA, the
pathname specification works fine, we can control which directories on
the mount point the application can access.

The same argument applies to server applications that access data served
NFS mount points. Consider a large application server that hosts all my
enterprise resource management stuff, and a large NAS server that hosts
the data. Perhaps the NAS server is a Network Appliance server, not even
using a Linux file system, just supplying NFS3 mounts.

The application server is hosting both the payroll system and the
customer relationship application. The data for both are on the NetApp,
serviced via NFS to the application server. I want to confine the
payroll application to access only the payroll data, and the CRM
application to access only CRM data.

The only way SELinux could do this would be to have anticipated the
problem and store my data on separate partitions, so you could supply
separate mount points. AppArmor can just use path specifications to
confine each application to its own part of a single NFS mount point. In
a perfect world the admin would use separate mount points, AppArmor is a
tool for an imperfect world.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

