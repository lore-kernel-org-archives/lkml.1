Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYCDCNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYCDCNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYCDCMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:12:47 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41507 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694AbYCDCMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:12:45 -0500
Date: Tue, 4 Mar 2008 07:43:15 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH][2.6.25-rc2-mm1] fix a null pointer bug in
	register_kretprobe
Message-ID: <20080304021315.GA7126@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <47CC7B1C.1060305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC7B1C.1060305@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 05:26:36PM -0500, Masami Hiramatsu wrote:
> X-Enigmail-Version: 0.95.6
> Content-Type: text/plain; charset=ISO-8859-1
> Content-Transfer-Encoding: 7bit
> X-Scanned-By: MIMEDefang 2.58 on 172.16.52.254
> 
>  Fix a bug in regiseter_kretprobe() which does not check
>  rp->kp.symbol_name == NULL before calling kprobe_lookup_name.
> 
>  For maintainability, this introduces kprobe_addr helper function which
>  resolves addr field. It is used by register_kprobe and register_kretprobe.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Masami!

> ---
>  kernel/kprobes.c |   43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
> 
> Index: 2.6.25-rc2-mm1/kernel/kprobes.c
> ===================================================================
> --- 2.6.25-rc2-mm1.orig/kernel/kprobes.c	2008-02-18 11:37:18.000000000 -0500
> +++ 2.6.25-rc2-mm1/kernel/kprobes.c	2008-02-18 11:37:18.000000000 -0500
> @@ -498,27 +498,36 @@ static int __kprobes in_kprobes_function
>  	return 0;
>  }
> 
> +/*
> + * If we have a symbol_name argument, look it up and add the offset field
> + * to it. This way, we can specify a relative address to a symbol.
> + */
> +static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
> +{
> +	kprobe_opcode_t *addr = p->addr;
> +	if (p->symbol_name) {
> +		if (addr)
> +			return NULL;
> +		kprobe_lookup_name(p->symbol_name, addr);
> +	}
> +
> +	if (!addr)
> +		return NULL;
> +	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
> +}
> +
>  static int __kprobes __register_kprobe(struct kprobe *p,
>  	unsigned long called_from)
>  {
>  	int ret = 0;
>  	struct kprobe *old_p;
>  	struct module *probed_mod;
> +	kprobe_opcode_t *addr;
> 
> -	/*
> -	 * If we have a symbol_name argument look it up,
> -	 * and add it to the address.  That way the addr
> -	 * field can either be global or relative to a symbol.
> -	 */
> -	if (p->symbol_name) {
> -		if (p->addr)
> -			return -EINVAL;
> -		kprobe_lookup_name(p->symbol_name, p->addr);
> -	}
> -
> -	if (!p->addr)
> +	addr = kprobe_addr(p);
> +	if (!addr)
>  		return -EINVAL;
> -	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
> +	p->addr = addr;
> 
>  	if (!kernel_text_address((unsigned long) p->addr) ||
>  	    in_kprobes_functions((unsigned long) p->addr))
> @@ -722,12 +731,12 @@ int __kprobes register_kretprobe(struct
>  	int ret = 0;
>  	struct kretprobe_instance *inst;
>  	int i;
> -	void *addr = rp->kp.addr;
> +	void *addr;
> 
>  	if (kretprobe_blacklist_size) {
> -		if (addr == NULL)
> -			kprobe_lookup_name(rp->kp.symbol_name, addr);
> -		addr += rp->kp.offset;
> +		addr = kprobe_addr(&rp->kp);
> +		if (!addr)
> +			return -EINVAL;
> 
>  		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
>  			if (kretprobe_blacklist[i].addr == addr)
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
