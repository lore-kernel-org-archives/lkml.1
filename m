Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZKNPWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZKNPWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 10:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZKNPWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 10:22:42 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:50767 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZKNPWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 10:22:41 -0500
Date: Sat, 14 Nov 2009 16:22:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Valdis.Kletnieks@vt.edu
Cc: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: <24306.1258153693@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0911141621480.3898@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
 <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com>
 <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com>
 <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org> <4AFCC06B.1030302@schaufler-ca.com>
 <19857.1258147396@turing-police.cc.vt.edu>           
 <Pine.LNX.4.64.0911132224370.6325@ask.diku.dk> <24306.1258153693@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 13 Nov 2009 22:26:20 +0100, Julia Lawall said:
> > On Fri, 13 Nov 2009, Valdis.Kletnieks@vt.edu wrote:
> > > Julia, is there a way to use coccinelle to detect unsafe changes like that?  Or
> > > is expressing those semantics too difficult?
> > 
> > Could you give a concrete example of something that would be a problem?
> > If something like alias analysis is required, to know what strings a 
> > variable might be bound to, that might be difficult.  Coccinelle works 
> > better when there is some concrete codeto match against.
> 
> Here's a concrete example of how a previously audited strcmp() can go bad...
> 
> struct foo {
>     char[16] a; /* old code allows 15 chars and 1 more for the \0 */
>     int b;
>     int c;
> }
> 
> bzero(foo,sizeof(foo));
> 
> Now code can pretty safely mess with the first 15 bytes of foo->a and
> we know we're OK if we call strcmp(foo->a,....) because that bzero()
> nuked a[15] for us. It's safe to strncpy(foo->a,bar,15); and not worry
> about the fact that if bar is 15 chars long, a trailing \0 won't be put in.
> 
> Now somebody comes along and does:
> 
> struct foo {
>     char *a; /* we need more than 15 chars for some oddball hardware */
>     int b;
>     int c;
> }
> 
> bzero(foo,sizeof(foo));
> foo->a = kmalloc(32);  /* whoops should have been kzmalloc */
> 
> Now suddenly, strncpy(foo->a,bar,31); *isn't* safe....
> 
> (Yes, I know there's plenty of blame to go around in this example - the failure
> to use kzmalloc, the use of strncpy() without an explicit \0 being assigned
> someplace, the use of strcmp() rather than strncmp()... But our tendency to
> intentionally omit several steps of this to produce more efficient code means
> it's easier to shoot ourselves in the foot...)

Thanks for the example.  Coccinelle only finds patterns of code in one 
version, while this would require considering two versions at once.  Such 
a thing could be interesting though.

julia
