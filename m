Return-Path: <linux-kernel-owner+w=401wt.eu-S1764420AbXFRTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764420AbXFRTlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbXFRTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:41:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:40740 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761392AbXFRTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tq1KLAb8EnMlE3OEKuBVS3yiy6xKmn8/bw9oj/oVDpcmz3paTG9pBw5quz0yKRV95pAWF5fZDiiNqbDoP7nlrd3hPCZ9bcOhhjW8oAtA+fQyh9HlkcTDqF+7M3mw2F5l1peW1qYmQtuWGwfHjQIhHZ4Qm99qo0Ts6wo6E8HVR6Q=
Date: Mon, 18 Jun 2007 23:43:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [RFC] Generic Trace Setup and Control (GTSC) kernel API (2/3)
Message-ID: <20070618194301.GA6038@martell.zuzino.mipt.ru>
References: <4676108B.9030203@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676108B.9030203@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 09:56:43PM -0700, David Wilder wrote:
> This patch introduces the Generic Trace Setup and Control (GTSC) API.
> In the kernel, GTSC provides a simple API for starting and managing
> data channels to user space.  GTSC builds on the relay interface.

My main grief is names choosing. gtsc_ prefixes are everywhere.
In fact doing s/gtsc//g on this patchset would produce better patch.
See below.

> --- /dev/null
> +++ b/include/linux/gtsc.h
> +/*
> + * GTSC channel flags
> + */
> +#define GTSC_GLOBAL	0x01
> +#define GTSC_FLIGHT	0x02

The fact that is channel flags is not deducable.

> +enum {
> +	Gtsc_trace_setup = 1,

Starting from zero seems unimportant. You check for equality anyway.
Or not?

> +	Gtsc_trace_running,
> +	Gtsc_trace_stopped,
> +};

All uppercase would be better.

> +/*
> + * Global root user information
> + */
> +struct gtsc_root {
> +	struct list_head list;
> +	char gtsc_name[GTSC_TRACE_ROOT_NAME_SIZE];
> +	struct dentry *gtsc_root;
> +	unsigned int gtsc_users;
> +};
> +
> +/*
> + * Client information
> + */
> +struct gtsc_trace {
> +	int trace_state;

named enum, please.

> +	struct dentry *state_file;
> +	struct rchan *rchan;
> +	struct dentry *dir;
> +	struct dentry *dropped_file;
> +	atomic_t dropped;
> +	struct gtsc_root *root;
> +	void *private_data;
> +	unsigned int flags;
> +	unsigned int buf_size;
> +	unsigned int buf_nr;
> +};
> +
> +static inline int gtsc_trace_running(struct gtsc_trace *gtsc)
> +{
> +	return gtsc->trace_state == Gtsc_trace_running;
> +}

Like here. Compare to

	static inline int trace_running(struct trace *trace)
	{
		return trace->state == TRACE_RUNNING;
	}

It's about traces not naming your particular project.

> +#if defined(CONFIG_GTSC)

#ifdef CONFIG_* usually

> +/**
> + *	gtsc_trace_startstop: start or stop tracing.
> + *
> + *	@gtsc: gtsc trace handle to start or stop.
> + *	@start: set to 1 to start tracing set to 0 to stop.
> + *
> + *	returns 0 if successful.
> + */
> +extern int gtsc_trace_startstop(struct gtsc_trace *gtsc, int start);

Two functions in one.

> +/**
> + *	gtsc_timestamp: returns a time stamp.
> + */
> +extern unsigned long long  gtsc_timestamp(void);

Isn't it obvious from name that timestamp is returned?

> +#else /* !CONFIG_GTSC */
> +#define gtsc_trace_setup(root, name, buf_size, buf_nr, flags)	(NULL)
> +#define gtsc_trace_startstop(gtsc, start)	(-EINVAL)
> +#define gtsc_trace_cleanup(gtsc)		do { } while (0)
> +#define gtsc_timestamp(void) 			(unsigned long long) (0)

static inlines, so those "foo is unused" warnings would not appear.

> +config GTSC
> +	bool "Generic Trace Setup and Control"
> +	select RELAY
> +	select DEBUG_FS
> +	help
> +	This option enables support for the GTSC. 

too small help text and trailing whitespace.
Help texts are usually indented like

	Tabhelp
	TabSpaceSpace[actual text]
	TabSpaceSpace[more text]

> --- /dev/null
> +++ b/lib/gtsc.c

> +static ssize_t gtsc_state_write(struct file *filp, const char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	struct gtsc_trace *gtsc = filp->private_data;
> +	char buf[16];
> +	int ret;
> +
> +	memset(buf, 0, sizeof(buf));
> +
> +	if (count > sizeof(buf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(buf, buffer, count))
> +		return -EFAULT;

This is too dangerous to leave without explicit placing of terminator.
Think someone will copy it without strncmp() usage.

> +	if (strncmp(buf, "start", strlen("start")) == 0 ) {
> +		ret = gtsc_trace_startstop(gtsc, 1);
> +		if (ret)
> +			return ret;
> +	} else if (strncmp(buffer, "stop", strlen("stop")) == 0) {
> +		ret = gtsc_trace_startstop(gtsc, 0);
> +		if (ret)
> +			return ret;
> +	} else
> +		return -EINVAL;
> +
> +	return count;
> +}
> +
> +
> +static struct file_operations gtsc_state_fops = {
> +	.owner =	THIS_MODULE,
> +	.open =		gtsc_state_open,
> +	.read =		gtsc_state_read,
> +	.write =	gtsc_state_write,

[Tab]=[Space][method], is nicer ;-)

> +static struct file_operations gtsc_dropped_fops = {
> +	.owner =	THIS_MODULE,
> +	.open =		gtsc_dropped_open,
> +	.read =		gtsc_dropped_read,
> +};

> +int gtsc_trace_startstop(struct gtsc_trace *gtsc, int start)
> +{
> +	int ret = -EINVAL;
> +	/*
> +	 * For starting a trace, we can transition from a setup or stopped
> +	 * trace. For stopping a trace, the state must be running
> +	 */
> +	if (start) {
> +		if (gtsc->trace_state == Gtsc_trace_setup) {
> +			ret = gtsc_trace_setup_channel(gtsc, gtsc->buf_size,
> +						       gtsc->buf_nr,
> +						       gtsc->flags);
> +			if (ret)
> +				return ret;
> +		}
> +		gtsc->trace_state = Gtsc_trace_running;
> +	} else {
> +		if (gtsc->trace_state == Gtsc_trace_running) {
> +			gtsc->trace_state = Gtsc_trace_stopped;
> +			relay_flush(gtsc->rchan);
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(gtsc_trace_startstop);

Can we get another user to justify this generalizing?

I also ask to remove extern from prototypes, making .h something like
20 lines long and move kernel-doc comments to *.c file.

