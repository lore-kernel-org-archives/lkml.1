Return-Path: <linux-kernel-owner+w=401wt.eu-S934649AbXG3NLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649AbXG3NLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 09:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbXG3NLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 09:11:32 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:46854 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032AbXG3NLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 09:11:31 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 09:11:31 EDT
Message-ID: <46ADDFB2.9070709@inf.ethz.ch>
Date: Mon, 30 Jul 2007 14:55:14 +0200
From: Stefan Walter <stefan.walter@inf.ethz.ch>
User-Agent: Mail/News 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: rpc.mountd crashes when extensively using netgroups
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2007 12:55:14.0449 (UTC) FILETIME=[DF352810:01C7D2A8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

we are seeing rpc.mountd crashes on our Red Hat EL4 systems.
We have tracked down the bug and it seems to be still present
in the current nfs-utils source.

We are making extensive use of netgroups for NFS exports. On
a large file server with hundreds of home directories we export
every directory to a unique netgroup. Member netgroups are used
to export to sets of machines. The following example illustrates
what we do:

# cat /etc/exports
/export/home/jane @jane(async,rw,no_subtree_check,fsid=10000)
/export/home/joe @joe(async,rw,no_subtree_check,fsid=10001)
# cat /etc/netgroup
lab_1 (workstation1,,) (workstation2,,) (workstation3)
offices_1 (workstation4,,) (workstation5,,)
jane lab_1 offices_1
joe offices_1 (joeslaptop,,)

We do this on a much larger scale though. The bug we ran into is
in line 96 in utils/mountd/auth.c. The strcpy can corrupt
memory when it copies the string returned by client_compose() to
my_client.m_hostname which has a fixed size of 1024 bytes. 
For our example above, client_compose() returns "@joe,@jane"
for any machine in the offices_1 netgroup. Unfortunately we have
a machine to which roughly 150 netgroups like @joe or @jane
export to and client_compose() returns a string over 1300 bytes
long and rpc.mountd nicely segfaults.
 
To prevent the crash is of course trivial: Inserting a simple
'if (strlen(n) > 1024) return NULL;' before line 96 does the job.

There are however two issues for which we could not find an easy
solution:

 1. For every client rpc.mountd and the kernel seem to exchange
    and use lists with _all_ netgroups used in exports that are
    relevant for granting permission to some share for a particular
    client. We could imagine two optimizations here:

       * Resolve netgroups and only put the (member) netgroups that
         contained the host name that would be used to authorize
         a mount in the list.

       * Use the list of mounted paths per client and only put the
         netgroup(s) used to export paths that are actually mounted
         on a client. 

    This also caused us severe performance problems because
    rpc.mountd queries all these netgroups. We were initially using
    a LDAP and mouting a directory took up to ten seconds
    during which rpc.mountd was busily querying the LDAP server.
    We got this down to two seconds using file based netgroups.
 
 2. Using a fixed size for NFSCLNT_IDMAX does not scale. Mounting
    shares on a client for which the 'if' clause of the quick fix
    becomes true will not be possible. We thought about enlarging
    NFSCLNT_IDMAX and using a custom kernel but dropped the idea. 

Our ultimate goal is to get Red Hat fix the code in nfs-utils 1.0.6
that is used in RHEL4. A first step would be to get a suitable fix in
the current nfs-utils. 

Is there somebody on the mailing list who could see an easy fix or
would have an opinion on how to best address the issues we see?

Thanks in advance and best regards,

Stefan


