Return-Path: <linux-kernel-owner+w=401wt.eu-S1751297AbZHXDHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbZHXDHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 23:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZHXDHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 23:07:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:43610 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZHXDHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 23:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TV7/IWQ+fFIvlEV0DHfZF080HJ621+IFOjbZE0HXIU3gExnNdR7xlBqnvIz5xyYHqx
         0Pp4U7R/keg2lN8Ha01oDrP6j5lHupD75nzGqKHxVSCir/4H3svRy6qjuK/6SWXfXLi+
         +rACVevBnVBMZQj1Z2C6NxxFcQLg9b53YwywQ=
Message-ID: <4A9203E8.307@gmail.com>
Date: Sun, 23 Aug 2009 20:07:20 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com> <4A8FA2BD.4030707@gmail.com> <4A91FDED.9050801@cn.fujitsu.com>
In-Reply-To: <4A91FDED.9050801@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> CC: Peter, Ingo
>
>    
>> Hey alright 2.6.31-rc6 booted.
>>
>> I must admit, I've been afraid of doing
>> a git bisect for some time now. but after learning
>> to do a bisect, I cant see a better solution to finding a
>> bug(biggest issue I see is having a huge .config).
>>
>> Anyways the culprit for my issue is this commit:
>>
>> af6af30c0fcd77e621638e53ef8b176bca8bd3b4
>>
>> reverting this on rc6 booted the machine up.
>>
>>      
>
> Thanks!
>
> Hmm...I don't see how this commit can cause oops:
>    

same here, perf  is not enabled at all.
before the git bisect I manually reverted all perf
and came to the conclusion the perf had nothing to do with this.
(must have missed this commit).
>    
>> @@ -119,11 +119,9 @@ struct ftrace_event_call {
>>          void                    *filter;
>>          void                    *mod;
>>
>> -#ifdef CONFIG_EVENT_PROFILE
>> -       atomic_t        profile_count;
>> -       int             (*profile_enable)(struct ftrace_event_call *);
>> -       void            (*profile_disable)(struct ftrace_event_call *);
>> -#endif
>> +       atomic_t                profile_count;
>> +       int                     (*profile_enable)(struct ftrace_event_call *);
>> +       void                    (*profile_disable)(struct ftrace_event_call *);
>>      
>
> In your .config, CONFIG_EVENT_PROFILE=y, so this change makes
> no difference.
>
>    
>>   };
>>
>>   #define MAX_FILTER_PRED                32
>> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profil
>> index 5b5895a..11ba5bb 100644
>> --- a/kernel/trace/trace_event_profile.c
>> +++ b/kernel/trace/trace_event_profile.c
>> @@ -14,7 +14,7 @@ int ftrace_profile_enable(int event_id)
>>
>>          mutex_lock(&event_mutex);
>>          list_for_each_entry(event,&ftrace_events, list) {
>> -               if (event->id == event_id) {
>> +               if (event->id == event_id&&  event->profile_enable) {
>>      
>
> You will run into this hunk only when you run the perf tool,
> so should have nothing to do with the boot failure.
>    
I haven't really looked into perf  yet, nor have it enabled.
>    
>>                          ret = event->profile_enable(event);
>>                          break;
>>                  }
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 23d2972..e75276a 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentr
>>                  entry = trace_create_file("enable", 0644, call->dir, call,
>>                                            enable);
>>
>> -       if (call->id)
>> +       if (call->id&&  call->profile_enable)
>>      
>
> We do an extra check on ->profile_enable, shouldn't cause bug..
>    
maybe this has something to do with SELinux, since I saw with
the oops something with inode_do_init_dentry, and some other stuff
pertaining to SELinux(again though I'm lost as to why I'm hitting this).
>    
>>                  entry = trace_create_file("id", 0444, call->dir, call,
>>                                            id);
>>      
>
> Any way, I don't think this commit does the right thing:
>
>    - If CONFIG_EVENT_PROFILE=y, we'll create events/<dir>/<event>/id,
>      except events/ftrace/<event>/id.
>
>    - if CONFIG_EVENT_PROFILE=n, there's no 'id' file at all!
>
> I think it's better to skip ftrace/ dir in perf tool code, instead of
> skipping creating id files in ftrace code.
>
> can you try this patch:
>
> ---
>   include/linux/ftrace_event.h   |    2 ++
>   kernel/trace/trace_events.c    |    2 +-
>   tools/perf/util/parse-events.c |    8 +++++++-
>   3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index a81170d..398c925 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -121,9 +121,11 @@ struct ftrace_event_call {
>   	void			*filter;
>   	void			*mod;
>
> +#ifdef CONFIG_EVENT_PROFILE
>   	atomic_t		profile_count;
>   	int			(*profile_enable)(struct ftrace_event_call *);
>   	void			(*profile_disable)(struct ftrace_event_call *);
> +#endif
>   };
>
>   #define MAX_FILTER_PRED		32
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index e75276a..23d2972 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>   		entry = trace_create_file("enable", 0644, call->dir, call,
>   					  enable);
>
> -	if (call->id&&  call->profile_enable)
> +	if (call->id)
>   		entry = trace_create_file("id", 0444, call->dir, call,
>   					  id);
>
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 0441784..1077ebd 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -113,13 +113,19 @@ static unsigned long hw_cache_stat[C(MAX)] = {
>    [C(BPU)]	= (CACHE_READ),
>   };
>
> +static int is_tp_subsystem(struct dirent *sys_dir)
> +{
> +	return !!strcmp(sys_dir->d_name, "ftrace");
> +}
> +
>   #define for_each_subsystem(sys_dir, sys_dirent, sys_next, file, st)	       \
>   	while (!readdir_r(sys_dir,&sys_dirent,&sys_next)&&  sys_next)	       \
>   	if (snprintf(file, MAXPATHLEN, "%s/%s", debugfs_path,	       	       \
>   			sys_dirent.d_name)&&		       		\
>   	   (!stat(file,&st))&&  (S_ISDIR(st.st_mode))&&		\
>   	   (strcmp(sys_dirent.d_name, "."))&&				\
> -	   (strcmp(sys_dirent.d_name, "..")))
> +	   (strcmp(sys_dirent.d_name, ".."))&&				\
> +	   (is_tp_subsystem(&sys_dirent)))
>
>   static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
>   {
>
>
>
>    
Alright, in the morning I try this out and let you
know what happens.

Thanks for looking at this.

Justin P. Mattock
