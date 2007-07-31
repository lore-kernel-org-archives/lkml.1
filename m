Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbXGaOBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbXGaOBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXGaOAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:00:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbXGaOAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:00:52 -0400
Message-ID: <46AF4034.6080507@RedHat.com>
Date: Tue, 31 Jul 2007 09:59:16 -0400
From: Steve Dickson <SteveD@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Stefan Walter <stefan.walter@inf.ethz.ch>
CC: linux-kernel@vger.kernel.org
Subject: Re: rpc.mountd crashes when extensively using netgroups
References: <46ADDFB2.9070709@inf.ethz.ch>
In-Reply-To: <46ADDFB2.9070709@inf.ethz.ch>
Content-Type: multipart/mixed;
 boundary="------------060808090307040103050703"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060808090307040103050703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Stefan Walter wrote:
> 
> We do this on a much larger scale though. The bug we ran into is
> in line 96 in utils/mountd/auth.c. The strcpy can corrupt
> memory when it copies the string returned by client_compose() to
> my_client.m_hostname which has a fixed size of 1024 bytes. 
> For our example above, client_compose() returns "@joe,@jane"
> for any machine in the offices_1 netgroup. Unfortunately we have
> a machine to which roughly 150 netgroups like @joe or @jane
> export to and client_compose() returns a string over 1300 bytes
> long and rpc.mountd nicely segfaults.
>  
> To prevent the crash is of course trivial: Inserting a simple
> 'if (strlen(n) > 1024) return NULL;' before line 96 does the job.
Does the attached patch help?

> 
> There are however two issues for which we could not find an easy
> solution:
> 
>  1. For every client rpc.mountd and the kernel seem to exchange
>     and use lists with _all_ netgroups used in exports that are
>     relevant for granting permission to some share for a particular
>     client. We could imagine two optimizations here:
> 
>        * Resolve netgroups and only put the (member) netgroups that
>          contained the host name that would be used to authorize
>          a mount in the list.
> 
>        * Use the list of mounted paths per client and only put the
>          netgroup(s) used to export paths that are actually mounted
>          on a client. 
These sound reasonable...


>  
>  2. Using a fixed size for NFSCLNT_IDMAX does not scale. Mounting
>     shares on a client for which the 'if' clause of the quick fix
>     becomes true will not be possible. We thought about enlarging
>     NFSCLNT_IDMAX and using a custom kernel but dropped the idea. 
True...

> 
> Our ultimate goal is to get Red Hat fix the code in nfs-utils 1.0.6
> that is used in RHEL4. A first step would be to get a suitable fix in
> the current nfs-utils. 
Please open up bugs on all three of these issues and
we'll see what can done...

steved.


--------------060808090307040103050703
Content-Type: text/x-patch;
 name="mountd-netgroup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mountd-netgroup.patch"

commit 851ce1cb766cf295db85900aab804c0f82c12ab3
Author: Steve Dickson <steved@redhat.com>
Date:   Tue Jul 31 09:57:19 2007 -0400

    Stop rpc.mound from crashing by m_hostname becoming
    corrupted with very long host names.
    
    Signed-off-by: Steve Dickson <steved@redhat.com>

diff --git a/utils/mountd/auth.c b/utils/mountd/auth.c
index f7fe23d..eff0ba7 100644
--- a/utils/mountd/auth.c
+++ b/utils/mountd/auth.c
@@ -93,7 +93,8 @@ auth_authenticate_internal(char *what, struct sockaddr_in *caller,
 		*error = unknown_host;
 		if (!n)
 			return NULL;
-		strcpy(my_client.m_hostname, *n?n:"DEFAULT");
+		snprintf(my_client.m_hostname, (NFSCLNT_IDMAX+1), 
+			"%s", *n?n:"DEFAULT");
 		free(n);
 		my_client.m_naddr = 1;
 		my_exp.m_client = &my_client;

--------------060808090307040103050703--
