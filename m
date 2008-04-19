Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbYDSVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbYDSVdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 17:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYDSVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 17:33:33 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:39051 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbYDSVdc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 17:33:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FAK4BCkhMROPA/2dsb2JhbACBYKhk
Date: Sat, 19 Apr 2008 17:33:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "K. Prasad" <prasad@linux.vnet.ibm.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080419213329.GB2831@Krystal>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415132512.GA22351@Krystal> <1208361084.6395.80.camel@twins> <20080417191910.GI28235@redhat.com> <20080417201644.GC31616@Krystal> <20080419121353.GA6688@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080419121353.GA6688@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:31:02 up 50 days, 17:42,  4 users,  load average: 0.67, 0.45,
	0.33
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* K. Prasad (prasad@linux.vnet.ibm.com) wrote:
> On Thu, Apr 17, 2008 at 04:16:44PM -0400, Mathieu Desnoyers wrote:
> > * Frank Ch. Eigler (fche@redhat.com) wrote:
> > [..]
> > > > >﻿+       trace_mark(futex_wake_called, "uaddr:%p fshared:%p nr_wake:%d "
> > > > > +                       "bitset:%d",
> > > > > +                       uaddr, fshared, nr_wake, bitset);
> > > > 
> > > > > +       INIT_FUTEX_DEBUG_PROBE(futex_wake_called,
> > > > > +                       "uaddr:%p fshared:%p nr_wake:%d bitset:%d"),
> > > > 
> > > > Why the need to duplicate it; that's utter madness.
> > > 
> > > This second instance is optional and is used as a consistency check
> > > for the event consumer to hook up exactly to the intended producer.
> > > The string could be empty.
> > > 
> > 
> > empty -> NULL , yes :)
> Atleast until 2.6.25-rc8-mm2, I would expect the marker registration to
> fail if the format strings don't match.
> I find an early return in set_marker() in marker.c if the format
> strings don't match.
> 
> Mathieu,
> 	Can you let me know if you would find the patch below - which
> eliminates the need to pass format string to marker_probe_register()
> function, acceptable?
> I have done some elementary tests with the patch, but I know it would
> fail if there are duplicate markers with different format strings.
> However I presume that duplicate markers are meant to appear primarily
> when markers are present in inlined functions (in which case their
> format strings would be the same).
> 

Sorry, I will have to NACK this one. A probe which registers on a marker
has two choices : either is passes a NULL format string, which tells the
marker infrastructure that th probe will dynamically parse the format
string to grab the arguments, like printk.

However, if the probe is expecting a particular layout of arguments, It
must tell so upon registration, so the marker infrastructure can check
if the marker it's trying to connect to still ave the same arguments.
That will make sure specialized probes won't break between kernel
version changes.

Mathieu

> Thanks,
> K.Prasad
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  include/linux/marker.h          |    4 ++--
>  kernel/marker.c                 |   40 +++++++++++++++++-----------------------
>  samples/markers/probe-example.c |    3 ---
>  3 files changed, 19 insertions(+), 28 deletions(-)
> 
> Index: linux-register_marker_patch/kernel/marker.c
> ===================================================================
> --- linux-register_marker_patch.orig/kernel/marker.c
> +++ linux-register_marker_patch/kernel/marker.c
> @@ -364,7 +364,7 @@ static struct marker_entry *get_marker(c
>   * Add the marker to the marker hash table. Must be called with markers_mutex
>   * held.
>   */
> -static struct marker_entry *add_marker(const char *name, const char *format)
> +static struct marker_entry *add_marker(const char *name)
>  {
>  	struct hlist_head *head;
>  	struct hlist_node *node;
> @@ -372,9 +372,15 @@ static struct marker_entry *add_marker(c
>  	size_t name_len = strlen(name) + 1;
>  	size_t format_len = 0;
>  	u32 hash = jhash(name, name_len-1, 0);
> +	struct marker *iter;
> +
> +	/* Search for the marker with 'name' in __markers section */
> +	for (iter = __start___markers;
> +		((iter < __stop___markers) && (strcmp(name, iter->name)));
> +			iter++);
>  
> -	if (format)
> -		format_len = strlen(format) + 1;
> +	if (iter->format)
> +		format_len = strlen(iter->format) + 1;
>  	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
>  	hlist_for_each_entry(e, node, head, hlist) {
>  		if (!strcmp(name, e->name)) {
> @@ -392,9 +398,9 @@ static struct marker_entry *add_marker(c
>  	if (!e)
>  		return ERR_PTR(-ENOMEM);
>  	memcpy(&e->name[0], name, name_len);
> -	if (format) {
> +	if (iter->format) {
>  		e->format = &e->name[name_len];
> -		memcpy(e->format, format, format_len);
> +		memcpy(e->format, iter->format, format_len);
>  		if (strcmp(e->format, MARK_NOARGS) == 0)
>  			e->call = marker_probe_cb_noarg;
>  		else
> @@ -494,21 +500,9 @@ static int set_marker(struct marker_entr
>  	int ret;
>  	WARN_ON(strcmp((*entry)->name, elem->name) != 0);
>  
> -	if ((*entry)->format) {
> -		if (strcmp((*entry)->format, elem->format) != 0) {
> -			printk(KERN_NOTICE
> -				"Format mismatch for probe %s "
> -				"(%s), marker (%s)\n",
> -				(*entry)->name,
> -				(*entry)->format,
> -				elem->format);
> -			return -EPERM;
> -		}
> -	} else {
> -		ret = marker_set_format(entry, elem->format);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = marker_set_format(entry, elem->format);
> +	if (ret)
> +		return ret;
>  
>  	/*
>  	 * probe_cb setup (statically known) is done here. It is
> @@ -638,8 +632,8 @@ static void marker_update_probes(void)
>   * Returns 0 if ok, error value on error.
>   * The probe address must at least be aligned on the architecture pointer size.
>   */
> -int marker_probe_register(const char *name, const char *format,
> -			marker_probe_func *probe, void *probe_private)
> +int marker_probe_register(const char *name, marker_probe_func *probe,
> +							void *probe_private)
>  {
>  	struct marker_entry *entry;
>  	int ret = 0;
> @@ -648,7 +642,7 @@ int marker_probe_register(const char *na
>  	mutex_lock(&markers_mutex);
>  	entry = get_marker(name);
>  	if (!entry) {
> -		entry = add_marker(name, format);
> +		entry = add_marker(name);
>  		if (IS_ERR(entry)) {
>  			ret = PTR_ERR(entry);
>  			goto end;
> Index: linux-register_marker_patch/include/linux/marker.h
> ===================================================================
> --- linux-register_marker_patch.orig/include/linux/marker.h
> +++ linux-register_marker_patch/include/linux/marker.h
> @@ -119,8 +119,8 @@ extern void marker_probe_cb_noarg(const 
>   * Connect a probe to a marker.
>   * private data pointer must be a valid allocated memory address, or NULL.
>   */
> -extern int marker_probe_register(const char *name, const char *format,
> -				marker_probe_func *probe, void *probe_private);
> +extern int marker_probe_register(const char *name, marker_probe_func *probe,
> +				void *probe_private);
>  
>  /*
>   * Returns the private data given to marker_probe_register.
> Index: linux-register_marker_patch/samples/markers/probe-example.c
> ===================================================================
> --- linux-register_marker_patch.orig/samples/markers/probe-example.c
> +++ linux-register_marker_patch/samples/markers/probe-example.c
> @@ -49,10 +49,8 @@ void probe_subsystem_eventb(void *probe_
>  static struct probe_data probe_array[] =
>  {
>  	{	.name = "subsystem_event",
> -		.format = "integer %d string %s",
>  		.probe_func = probe_subsystem_event },
>  	{	.name = "subsystem_eventb",
> -		.format = MARK_NOARGS,
>  		.probe_func = probe_subsystem_eventb },
>  };
>  
> @@ -63,7 +61,6 @@ static int __init probe_init(void)
>  
>  	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
>  		result = marker_probe_register(probe_array[i].name,
> -				probe_array[i].format,
>  				probe_array[i].probe_func, &probe_array[i]);
>  		if (result)
>  			printk(KERN_INFO "Unable to register probe %s\n",

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
