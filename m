Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYCJSaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYCJSaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYCJS37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:29:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:57483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCJS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qw2Q4eQJZRJUrPE8IuBTVoaryrOik1LL5JHtrnJijKYljfimbjj+0Q+9bahrxNgLEwc0E115VxKncv//t92eO7AIVAEIQkl0i5nvLhSNTIXjBBVkFQwq3X4zneb5hyfX6f7hqmvPUsx8Iedop7VUEbNpSsdauyziwau+44RWpDo=
Date: Mon, 10 Mar 2008 20:26:34 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>
Subject: Re: [RFC][PATCH] Smack<->Audit integration
Message-ID: <20080310182634.GA448@ubuntu>
References: <20080310124928.GA30534@ubuntu> <135060.71118.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <135060.71118.qm@web36610.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 09:07:08AM -0700, Casey Schaufler wrote:
> 
> --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> 
...
> > 
> > diff --git a/security/smack/smack.h b/security/smack/smack.h
> > index c444f48..2c8bb4c 100644
> > --- a/security/smack/smack.h
> > +++ b/security/smack/smack.h
> > @@ -57,6 +57,15 @@ struct inode_smack {
> >  	char		*smk_inode;	/* label of the fso */
> >  	struct mutex	smk_lock;	/* initialization lock */
> >  	int		smk_flags;	/* smack inode flags */
> > +	int		secid;		/* security identifier */
> 
> No.
> 
> Secid's are horrid things and every effort should be made to
> expunge them from the known universe. Under no circumstances
> should thier use be expanded. The only reason Smack has them
> at all is because certain interfaces that in my mind should
> have known better use them. If you must deal with secids,
> and for this round of audit I think that's a given, use
> smack_to_secid(sp->smk_inode) where you need to. If there's a
> real performance issue apply intelligence to smack_to_secid
> instead of storing the secid. There ought to be a way to
> use container_of to do smack_to_secid, but I had trouble with
> that and moved along without figuring out what I had done
> wrong.
> 

mm .. I should have remembered the un-official Smack motto:
"Everything is a label, and whenever possible, this label is allocated
 once through system lifetime"

About performance, yes there'll be issues searching labels espicially
in audit_rule_match() which got called at the end of every system call.
I'll try it using container_of (it should work at the end).

...
>
> > @@ -1696,9 +1738,9 @@ static int smack_msg_queue_alloc_security(struct
> > msg_queue *msq)
> >   */
> >  static void smack_msg_queue_free_security(struct msg_queue *msq)
> >  {
> > -	struct kern_ipc_perm *kisp = &msq->q_perm;
> > +	struct kern_ipc_perm *ipcp = &msq->q_perm;
> >  
> > -	kisp->security = NULL;
> > +	kfree(ipcp->security);
> >  }
> 
> Don't you just hate repetative reviewers?
>

Probably hating secids with passion :) ?

Admittedly, after some thinking I felt now that they don't fit with
the Smack model very well.

...
> > +
> > +/**
> > + * smack_audit_rule_match - Audit given secid identified object ?
> > + * @secid: Security id to test
> > + * @field: Message flags given from user-space
> > + * @op: Required operation (only equality is allowed)
> > + * @vrule: Smack audit rule that will be checked against the secid object
> > + * @actx: audit context associated with the check (used for Audit logging)
> > + *
> > + * This is the core Audit hook. It's used to identify objects like 
> > + * syscalls and inodes requested from user-space to be audited from 
> > + * remaining kernel objects.
> > + */
> > +static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
> > +				  struct audit_context *actx)
> > +{
> > +	struct smack_known *smk_rule = vrule;
> 
>         char *smack;
> 

More of "everything is a label".

> > +
> > +	if (!smk_rule) {
> > +		audit_log(actx, GFP_KERNEL, AUDIT_SELINUX_ERR,
> > +			  "Smack: missing rule\n");
> > +		return -ENOENT;
> > +	}
> > +
> > +	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
> > +		return 0;
> > +
> 
>         smack = smack_from_secid(secid);
> 
> > +	if (op == AUDIT_EQUAL)
> > +		return (smk_rule->smk_secid == secid);
> > +	if (op == AUDIT_NOT_EQUAL)
> > +		return (smk_rule->smk_secid != secid);
> 
>  	if (op == AUDIT_EQUAL)
> 		return (smk_rule->smk_smack == smack);
> 	if (op == AUDIT_NOT_EQUAL)
> 		return (smk_rule->smk_smack == smack);
> 

You've meant using the short-circuit:
	 smk_rule->smk_smack == smack || strnmp(smack, ..., ..)
Right ?

...
> > +
> > +/**
> > + * smack_audit_rule_free - free internal audit rule representation
> > + * @vrule: rule to be freed.
> > + *
> > + * No memory was allocated in audit_rule_init.
> > + */
> > +static void smack_audit_rule_free(void *vrule)
> > +{
> > +	/* No-op */
> > +}

This little no-op was the only thing that was agreed upon ;)

...
> 
> Casey Schaufler
> casey@schaufler-ca.com

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

