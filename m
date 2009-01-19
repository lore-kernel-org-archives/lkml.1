Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbZASUHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbZASUHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZASUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:07:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33060 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZASUHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:07:04 -0500
Date: Mon, 19 Jan 2009 21:04:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>,
       hpa@zytor.com, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] autofs: fix the wrong usage of the deprecated
	task_pgrp_nr()
Message-ID: <20090119200420.GA26977@redhat.com>
References: <20090119083208.GA25297@redhat.com> <1232363717.3136.134.camel@zeus.themaw.net> <20090119124253.GA3268@redhat.com> <1232372016.3136.155.camel@zeus.themaw.net> <20090119143046.GA8284@redhat.com> <20090119174836.GA11295@us.ibm.com> <20090119180534.GA22913@redhat.com> <20090119182447.GA15140@us.ibm.com> <20090119191729.GB24852@redhat.com> <20090119193553.GA18170@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119193553.GA18170@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > 
> > Actually, I am very much surprized this one-liner patch has so
> > many questions. Isn't it "obiously correct" ?
> 
> I'm not sure which one-liner you're talking about.  In fact,
> the patch I'm looking at right now isn't the one i looked at
> before my last response.  Dangit.
> 
> The patch turning the cached pid_t into a struct pid is
> certainly mostly right.  It shouldn't store a pid_t.

This is the next patch. This one does

	--- CUR/fs/autofs/inode.c~1_AUTOFS	2009-01-12 23:07:46.000000000 +0100
	+++ CUR/fs/autofs/inode.c	2009-01-18 06:18:49.000000000 +0100
	@@ -78,7 +78,7 @@ static int parse_options(char *options, 
	 
		*uid = current_uid();
		*gid = current_gid();
	-	*pgrp = task_pgrp_nr(current);
	+	*pgrp = task_pgrp_vnr(current);
	 
		*minproto = *maxproto = AUTOFS_PROTO_VERSION;

> But as for passing pid_t's in from userspace

passing pid_t's in from userspace uses current namespace, with
or without the patch.

> and especially
> printing them out in error messages, I believe what Ian was
> trying to do before, which seemed sensible, was to always
> use values in the init_pid_ns.  After all, if you do a DPRINTK
> with pid_vnr(somepid), then by the time a human reads the logs
> the subjective pidns might no longer exist.  So for logs I'd
> tend to agree with printing out the pid_t in the init_pid_ns.

OK, may be this makes sense, this was not discussed yet. This
can be changed. But otoh, if this code runs within the sub
namespace, then it is not easy to see why oz_mode == true
if we print the value in init_pid_ns.

Oleg.

