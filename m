Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZBVPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZBVPbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 10:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZBVPbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 10:31:01 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34789 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbZBVPbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 10:31:01 -0500
Date: Sun, 22 Feb 2009 07:31:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: etienne <etienne.basset@numericable.fr>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, casey@schaufler-ca.com,
       paul.moore@hp.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SMACK] convert smack rule list to linux list
Message-ID: <20090222153104.GF6860@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49A13E15.6020509@numericable.fr> <200902222040.CAB86425.VMOQHFFFtOSLOJ@I-love.SAKURA.ne.jp> <49A14FBE.7020206@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A14FBE.7020206@numericable.fr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 02:14:38PM +0100, etienne wrote:
> Tetsuo Handa wrote:
> > etienne wrote:
> >> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> >> index 2e0b83e..3dc312d 100644
> >> --- a/security/smack/smack_access.c
> >> +++ b/security/smack/smack_access.c
> >> @@ -87,7 +87,6 @@ static u32 smack_next_secid = 10;
> >>  int smk_access(char *subject_label, char *object_label, int request)
> >>  {
> >>  	u32 may = MAY_NOT;
> >> -	struct smk_list_entry *sp;
> >>  	struct smack_rule *srp;
> >>  
> >>  	/*
> >> @@ -139,8 +138,8 @@ int smk_access(char *subject_label, char *object_label, int request)
> >>  	 * access (e.g. read is included in readwrite) it's
> >>  	 * good.
> >>  	 */
> >> -	for (sp = smack_list; sp != NULL; sp = sp->smk_next) {
> >> -		srp = &sp->smk_rule;
> >> +
> >> +	list_for_each_entry(srp, &smack_rule_list, list) {
> >>  
> >>  		if (srp->smk_subject == subject_label ||
> >>  		    strcmp(srp->smk_subject, subject_label) == 0) {
> > 
> > Use of standard doubly linked list requires a lock, doesn't it?
> > What lock protects smack_rule_list?
> > 
> you're right; 
> 
> what's the best way, using a rcu variant for "list_for_each, container_of ...etc" ?
> (concurrent list insertion are already protected with a mutex, so rcu must the good idea for the read side) 

You want list_for_each_entry_rcu() above.  You will need list_add_rcu()
when adding elements to the list.

Again, if these elements are ever removed, you will need rcu_read_lock()
and rcu_read_unlock() surrounding their use.  Otherwise, an element can
be freed out from under a reader who is still referencing it.

							Thanx, Paul
