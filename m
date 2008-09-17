Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYIQWF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYIQWF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYIQWFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:05:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37842 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYIQWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:05:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, jmorris@namei.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<SpS7rta8n4.A.i9G.ZcsyIB@albercik>
	<alpine.LRH.1.10.0809130812460.12313@tundra.namei.org>
	<20080912152443.c4e59f42.akpm@linux-foundation.org>
	<alpine.LRH.1.10.0809131012310.13073@tundra.namei.org>
	<20080913123722.e238ae2a.akpm@linux-foundation.org>
	<1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil>
	<20080917125053.1f9ecf37.akpm@linux-foundation.org>
Date: Wed, 17 Sep 2008 14:56:17 -0700
In-Reply-To: <20080917125053.1f9ecf37.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 17 Sep 2008 12:50:53 -0700")
Message-ID: <m1abe6308u.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0079]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Bug #11500] /proc/net bug related to selinux
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 15 Sep 2008 09:05:26 -0400
> Stephen Smalley <sds@tycho.nsa.gov> wrote:

>> On Sat, 2008-09-13 at 12:37 -0700, Andrew Morton wrote:
>> However, the most likely explanation is simply that when /proc/net was
>> changed from being a directory to being a symlink to /proc/self/net,
>> that introduced an additional permission check on accesses
>> of /proc/net/<whatever>, namely the read check on the symlink itself.
>> And since that check wasn't happening on /proc/net accesses with older
>> kernels, older policies didn't allow it.

>> As to why others haven't reported it, I expect that they have updated
>> their policies to newer ones that allow the necessary access.  The fact
>> that legacy distros wouldn't have such updated policies isn't surprising
>> - they don't push updates to those distros for new kernels.  FC5 and FC6
>> are both EOL'd, right?
>> 
>> In any event, we didn't change anything in SELinux - the change was
>> elsewhere (in the proc/net implementation).  Don't blame the messenger
>> please.
>> 
>
> Vanilla FC5 broke and vanilla FC6 broke.  Did vanilla FC7, 8 or 9 break?
>
> http://smolt.fedoraproject.org/static/stats/stats.html shows 11,000-odd
> people running FC5 and FC6.  It would be incautious to assume that all
> those people have updated their selinux rules.
>
> And _requiring_ people to update their selinux rules to fix a
> kernel-caused regression is a pretty big deal for some people, I
> expect.

> Then again, given that this regression has been out there since 2.6.25,
> I guess not too many people are hurting from it.  But we suck.

Looking at this discussion closely from what I see selinux is designed
to work on the principle of least privilege.  If you make a user space
visible but compatible change, selinux will keep the system until
you update selinux.  Is selinux exposing too much to user space?
    
selinux was taken into consideration when the change was made.
The patch was even updated with feedback from Stephen Smiley.

> commit e9720acd728a46cb40daa52c99a979f7c4ff195c
> Author: Pavel Emelyanov <xemul@openvz.org>
> Date:   Fri Mar 7 11:08:40 2008 -0800
> 
>     [NET]: Make /proc/net a symlink on /proc/self/net (v3)
>     
>     Current /proc/net is done with so called "shadows", but current
>     implementation is broken and has little chances to get fixed.
>     
>     The problem is that dentries subtree of /proc/net directory has
>     fancy revalidation rules to make processes living in different
>     net namespaces see different entries in /proc/net subtree, but
>     currently, tasks see in the /proc/net subdir the contents of any
>     other namespace, depending on who opened the file first.
>     
>     The proposed fix is to turn /proc/net into a symlink, which points
>     to /proc/self/net, which in turn shows what previously was in
>     /proc/net - the network-related info, from the net namespace the
>     appropriate task lives in.
>     
>     # ls -l /proc/net
>     lrwxrwxrwx  1 root root 8 Mar  5 15:17 /proc/net -> self/net
>     
>     In other words - this behaves like /proc/mounts, but unlike
>     "mounts", "net" is not a file, but a directory.
>     
>     Changes from v2:
>     * Fixed discrepancy of /proc/net nlink count and selinux labeling
>       screwup pointed out by Stephen.
>     
>       To get the correct nlink count the ->getattr callback for /proc/net
>       is overridden to read one from the net->proc_net entry.
>     
>       To make selinux still work the net->proc_net entry is initialized
>       properly, i.e. with the "net" name and the proc_net parent.
>     
>     Selinux fixes are
>     Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
>     
>     Changes from v1:
>     * Fixed a task_struct leak in get_proc_task_net, pointed out by Paul.
>     
>     Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>     Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

