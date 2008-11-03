Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYKCHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYKCHdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYKCHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:33:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45489 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYKCHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:33:06 -0500
Date: Mon, 3 Nov 2008 08:32:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: T?r?k Edwin <edwintorok@gmail.com>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081103073257.GA13727@elte.hu>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081102214042.GG28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sun, Nov 02, 2008 at 11:28:20PM +0200, T?r?k Edwin wrote:
> > On 2008-11-02 23:25, Al Viro wrote:
> > > On Sun, Nov 02, 2008 at 11:18:14PM +0200, T??r??k Edwin wrote:
> > >   
> > >> +static int
> > >> +trace_seq_path(struct trace_seq *s, struct path *path)
> > >> +{
> > >> +	int ret;
> > >> +	struct seq_file m;
> > >> +	m.count = s->len;
> > >> +	m.size = PAGE_SIZE;
> > >> +	m.buf = s->buffer;
> > >> +	ret = seq_path(&m, path, "\n");
> > >> +	if (ret)
> > >> +		s->len = m.count;
> > >> +	return ret;
> > >> +}
> > >>     
> > >
> > > NAK.  seq_path() is a blatantly wrong thing to use here.
> > >   
> > 
> > Are there any alternatives I could use?
> > 
> > This function is called when I do 'cat /sys/kernel/debug/trace', not
> > during tracing itself.
> 
> _IF_ you want to get the mangled path, you want to take the guts of 
> seq_path() into a separate helper and use it - without any 
> references to struct seq_file since it's completely irrelevant there 
> and you are using it only as a vehicle for passing the stuff you 
> care about through the seq_path() interface.

could you please help out with such a helper? This is really about 
visualization, not to rely on it.

	Ingo
