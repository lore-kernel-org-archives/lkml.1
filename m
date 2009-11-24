Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZKXDbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZKXDbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbZKXDbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:31:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:12132 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbZKXDbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k7y21/akswK9FLWRLuL9UxXNFoud3V7eKhhOPOhVUyr6/QmnpVPhm+Q2wdX1sl2MRX
         Ntsi5uqdoWd2qNSyaskEsTCYZ+ss8BMjl1oJSWLX3Ncs37VuqUlOImNIA/xEd8mxfyuj
         rC18/hzl/dFdVZ+8771EyuhwUJnmqdnewpiY0=
Date: Tue, 24 Nov 2009 04:31:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump
	optimization
Message-ID: <20091124033135.GE6752@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com> <20091124024417.GA6752@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124024417.GA6752@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 03:44:19AM +0100, Frederic Weisbecker wrote:
> On Mon, Nov 23, 2009 at 06:21:41PM -0500, Masami Hiramatsu wrote:
> > +static void kprobe_optimizer(struct work_struct *work);
> > +static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
> > +#define OPTIMIZE_DELAY 5
> > +
> > +/* Kprobe jump optimizer */
> > +static __kprobes void kprobe_optimizer(struct work_struct *work)
> > +{
> > +	struct optimized_kprobe *op, *tmp;
> > +
> > +	/* Lock modules while optimizing kprobes */
> > +	mutex_lock(&module_mutex);
> > +	mutex_lock(&kprobe_mutex);
> > +	if (kprobes_all_disarmed)
> > +		goto end;
> > +
> > +	/* Wait quiesence period for ensuring all interrupts are done */
> > +	synchronize_sched();
> 
> 
> 
> It's not clear to me why you are doing that.
> Is this waiting for pending int 3 kprobes handlers
> to complete? If so, why, and what does that prevent?


I _might_ have understood.
You have set up the optimized flags, then you wait for
any old-style int 3 kprobes to complete and route
to detour buffer so that you can patch the jump
safely in the dead code? (and finish with first byte
by patching the int 3 itself)

