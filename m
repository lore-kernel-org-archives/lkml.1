Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZE2GBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZE2GBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZE2GB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:01:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:34205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZE2GB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ng7dHOxViAMi+SLzKkuAUGlrIstyJF13LJBk42Puau3MDDeJHNb2PPIEYgzKPgdB8p
         yqMIO8eGD+vcf1kZZvFU7uMhPejZSvVcw8/BK3cneympe0OFEka9Aw4/NTvrJj/qp95a
         v3QnrsqF8e4GTijWMjZGb9klNq92ZDCjb9h5Q=
Date: Fri, 29 May 2009 10:01:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090529060131.GA5504@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain> <4A1DA8FB.3000306@cs.columbia.edu> <20090527221753.GB8321@x200.localdomain> <4A1DC270.8080807@cs.columbia.edu> <20090528153322.GB18256@x200.localdomain> <4A1F0E29.2040506@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1F0E29.2040506@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 06:20:25PM -0400, Oren Laadan wrote:
> Alexey Dobriyan wrote:
> > Price in loose case is strictly bigger than price in strict case
> > because set of loose states is strict superset of set of strict cases.
> 
> The code to enforce full-container approach is a *superset* of the
> code without this requirement.
> 
> If you can checkpoint a full container, surely you can checkpoint a
> sub-hierarchy of processes.

No!

To checkpoint uts_ns reliably, in strict case, one doesn't even need
uts_sem.

In loose case, one needs uts_sem.

	static int dump_uts_ns(struct kstate_context *ctx, struct kstate_object *obj)
	{
		struct uts_namespace *uts_ns = obj->o_obj;
		struct kstate_image_uts_ns *i;
		int rv;
	
		i = kstate_prepare_image(KSTATE_OBJ_UTS_NS, sizeof(*i));
		if (!i)
			return -ENOMEM;
	
		if (ctx->dump_live)
			down_read(&uts_sem);
		strncpy(i->sysname, (const char *)uts_ns->name.sysname, 64);
		strncpy(i->nodename, (const char *)uts_ns->name.nodename, 64);
		strncpy(i->release, (const char *)uts_ns->name.release, 64);
		strncpy(i->version, (const char *)uts_ns->name.version, 64);
		strncpy(i->machine, (const char *)uts_ns->name.machine, 64);
		strncpy(i->domainname, (const char *)uts_ns->name.domainname, 64);
		if (ctx->dump_live)
			up_read(&uts_sem);

		rv = kstate_write_image(ctx, i, sizeof(*i), obj);
		kfree(i);
		return rv;
	}
