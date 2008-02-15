Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbYBOVBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbYBOVBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762612AbYBOVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:00:35 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:23498 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764355AbYBOVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:00:32 -0500
X-YMail-OSG: cnpDpTcVM1k2u7Cava__d02u4ICU8ks5KnY9c94gFsG8UeL_pOml5YrWWk54iylyJFP40p4SPtu1KX9dDpNDChourQAeAiZOstU4zov9rCKJ2x6MbikCEj5RQwwaQQ--
X-RocketYMMF: rancidfat
Date: Fri, 15 Feb 2008 13:00:26 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] (02/14/08 Linus git) Smack unlabeled outgoing ambient packets - v3
To: Paul Moore <paul.moore@hp.com>, casey@schaufler-ca.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <200802151359.35049.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <291070.74513.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Paul Moore <paul.moore@hp.com> wrote:

> On Friday 15 February 2008 12:38:49 am Casey Schaufler wrote:
> > From: Casey Schaufler <casey@schaufler-ca.com>
> >
> > Smack uses CIPSO labeling, but allows for unlabeled packets
> > by specifying an "ambient" label that is applied to incoming
> > unlabeled packets. Because the other end of the connection
> > may dislike IP options, and ssh is one know application that
> > behaves thus, it is prudent to respond in kind. This patch
> > changes the network labeling behavior such that an outgoing
> > packet that would be given a CIPSO label that matches the
> > ambient label is left unlabeled. An "unlbl" domain is added
> > and the netlabel defaulting mechanism invoked rather than
> > assuming that everything is CIPSO. Locking has been added
> > around changes to the ambient label as the mechanisms used
> > to do so are more involved.
> >
> > Cleaned up some issues noted in review.
> > Make smk_cipso_doi() static.
> > Create a hook for the new security_secctx_to_secid()
> > using existing underlying code.
> > Fill in audit data for netlbl domain calls.
> > Collapse unnecessary multiple assignments.
> >
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Hi Casey,
> 
> Thanks for the update, it's much improved.  I'd ack it except for one 
> last thing which popped up in this revision ... (and don't worry, it's 
> kinda my fault - not yours) ...
> 
> > @@ -1282,15 +1281,21 @@ static int smack_netlabel(struct sock *s
> >  {
> >  	struct socket_smack *ssp;
> >  	struct netlbl_lsm_secattr secattr;
> > -	int rc = 0;
> > +	int rc;
> >
> >  	ssp = sk->sk_security;
> >  	netlbl_secattr_init(&secattr);
> >  	smack_to_secattr(ssp->smk_out, &secattr);
> > -	if (secattr.flags != NETLBL_SECATTR_NONE)
> > -		rc = netlbl_sock_setattr(sk, &secattr);
> > -
> > +	rc = netlbl_sock_setattr(sk, &secattr);
> >  	netlbl_secattr_destroy(&secattr);
> > +
> > +	/*
> > +	 * A return of -ENOENT from netlbl_sock_setattr
> > +	 * indicates that the "domain" was not found, but that's
> > +	 * not an issue because of the defaulting behavior.
> > +	 */
> > +	if (rc == -ENOENT)
> > +		rc = 0;
> >  	return rc;
> >  }
> 
> ... you shouldn't fix-up the return value from netlbl_sock_setattr().  
> It only returns an error when there really is an error, if there are no 
> matching domain mappings and the default catches the "domain" then the 
> function will return 0 (assuming no other failures).
> 
> The fact that you ran into this problem isn't your fault, it's mine, but 
> thankfully for both of us Pavel Emelyanov found this bug and fixed 
> it[1].  It hasn't hit Linus' tree yet but it's in the net-2.6 tree.  If 
> you can't wait for it to hit Linus' tree you can always apply the fix 
> by hand, it's pretty minor.
> 
> Sorry about that.
> 
>
[1]http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=4c3a0a254e5d706d3fe01bf42261534858d05586

Yerk. I can put that fix into my tree, but my patch without
the "correction" makes sockets behave very badly. I can't have
people using it without Pavel's fix. Any notion on the plans to
get that in?

Thank you.


Casey Schaufler
casey@schaufler-ca.com
