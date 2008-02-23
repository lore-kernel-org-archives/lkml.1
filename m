Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYBWPWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYBWPWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYBWPWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:22:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:59074 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYBWPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:22:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vI3hWzdqGdqTvJa/XRE8uytOmexaV2rccL0UaxbLQIPUod8ijWxEwk99KmLGeD4He
	IIR71OyCjIglYzIXzraGw==
Message-ID: <6599ad830802230722u573ca4d6n46c4fce3cdcc149d@mail.gmail.com>
Date: Sat, 23 Feb 2008 07:22:37 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] cgroup map files: Add cgroup map data type
Cc: kamezawa.hiroyu@jp.fujitsu.com, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
In-Reply-To: <20080223000419.d446ac74.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221212854.408662000@menage.corp.google.com>
	 <20080221213444.898896000@menage.corp.google.com>
	 <20080223000419.d446ac74.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:04 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  > +static int cgroup_map_add(struct cgroup_map_cb *cb, const char *key, u64 value)
>  > +{
>  > +     struct seq_file *sf = cb->state;
>  > +     return seq_printf(sf, "%s %llu\n", key, value);
>  > +}
>
>  We don't know what type the architecture uses to implement u64.  This will
>  warn on powerpc, sparc64, maybe others.

OK, I'll add an (unsigned long long) cast.

>
>
>  > +static int cgroup_seqfile_show(struct seq_file *m, void *arg)
>  > +{
>  > +     struct cgroup_seqfile_state *state = m->private;
>  > +     struct cftype *cft = state->cft;
>  > +     if (cft->read_map) {
>  > +             struct cgroup_map_cb cb = {
>  > +                     .fill = cgroup_map_add,
>  > +                     .state = m,
>  > +             };
>  > +             return cft->read_map(state->cgroup, cft, &cb);
>  > +     } else {
>  > +             BUG();
>
>  That's not really needed.  Just call cft->read_map unconditionally.  if
>  it's zero we'll get a null-pointer deref which will have just the same
>  effect as a BUG.

OK. The long-term plan is to have other kinds of files also handled by
this function, so eventually it would look something like:

if (cft->read_map) {
...
} else if (cft->read_something_else) {
...
}
...
} else {
  BUG();
}

But I guess I can save that for the future.

>  >  static int cgroup_file_open(struct inode *inode, struct file *file)
>  >  {
>  >       int err;
>  > @@ -1499,7 +1539,18 @@ static int cgroup_file_open(struct inode
>  >       cft = __d_cft(file->f_dentry);
>  >       if (!cft)
>  >               return -ENODEV;
>  > -     if (cft->open)
>  > +     if (cft->read_map) {
>
>  But above a NULL value is illegal.  Why are we testing it here?
>
>

The existence of cft->read_map causes us to open a seq_file. Otherwise
we do nothing special and carry on down the normal open path.

Paul
