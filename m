Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXJRUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXJRUNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbXJRUNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:13:07 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:46839 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752801AbXJRUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:13:05 -0400
X-YMail-OSG: _j_q0fUVM1mpphlvYrp8Qbny0tbAi5YcqR92DYDgzSRpNOW_LFisRM.hTAanDvYhnqtAe9BE9A--
X-RocketYMMF: rancidfat
Date: Thu, 18 Oct 2007 13:13:02 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 8 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
To: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071018045705.GM8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <986439.75573.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Al Viro <viro@ftp.linux.org.uk> wrote:

> On Tue, Oct 16, 2007 at 09:17:40PM -0700, Casey Schaufler wrote:
> 
> At random:
> 
> > +static int smack_netlabel(struct sock *sk)
> > +{
> > +	static int initialized;
> > +	struct socket_smack *ssp = sk->sk_security;
> > +	struct netlbl_lsm_secattr secattr;
> > +	int rc = 0;
> > +
> > +	if (!initialized) {
> > +		smk_cipso_doi();
> > +		initialized = 1;
> > +	}
> 
> And just what happens if another task calls the same while we are
> blocked on allocation in smk_cipso_doi()?

I assume that swapping the two lines,

	initialized = 1;
 	smk_cipso_doi();

although it looks like it would suffice, isn't really good enough.

> Another problem is your handling of smk_known - you add to head under
> mutex; fine.  However, you read without one _and_ have no barriers
> in initializing new list entries.
> 
> Think what happens if CPU1 adds to list and CPU2 sees write to smk_known
> *before* it sees write to ->smk_next.  We see a single-element list and
> we'll be lucky if that single entry won't be FUBAR.

Help me understand this:

        if (skp == NULL) {
                skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
                if (skp != NULL) {
                        skp->smk_next = smack_known;
                        strncpy(skp->smk_known, smack, SMK_MAXLEN);
                        skp->smk_secid = smack_next_secid++;
                        skp->smk_cipso = NULL;
                        spin_lock_init(&skp->smk_cipsolock);
                        smack_known = skp;
                }
        }

CPU1 sets smk_next to smack_known. 
CPU1 fills in the rest of the entry.
CPU1 sets smack_known to skp (the entry).

CPU2 will either see the old value for smack_known,
in which case this entry isn't actually on the list yet,
or it will see the new value in smack_known. Since smk_next
is set before the entry is added to the list, it seems that
the scenario you've outlined shouldn't happen. I assume then
that you're refering to a case where the memory seen by the
two CPUs doesn't match. That still wouldn't account for the
"single entry list" notion. If CPU2 sees anything in smk_next
it should be the old smack_known.



Casey Schaufler
casey@schaufler-ca.com
