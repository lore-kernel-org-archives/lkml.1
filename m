Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZCWKf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZCWKf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZCWKfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:35:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZCWKfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <1237801506.2485.7.camel@ht.satnam>
References: <1237755176.5417.16.camel@ht.satnam>
	 <200903231845.05394.rusty@rustcorp.com.au>
	 <1237801506.2485.7.camel@ht.satnam>
Date: Mon, 23 Mar 2009 11:35:06 +0100
Message-ID: <154e089b0903230335q1fbdcc4biea140738b01e7a36@mail.gmail.com>
Subject: Re: [git-pull -tip] x86: cleanup patches 20090322
From: Hannes Eder <hannes@hanneseder.net>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 10:45 AM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> On Mon, 2009-03-23 at 18:45 +1030, Rusty Russell wrote:
>> On Monday 23 March 2009 07:22:56 Jaswinder Singh Rajput wrote:
>> >       x86: e820.h fix various signedness issues in setup.c and e820.c
>>
>> Wouldn't fixing the users be better than changing the header?  Esp. since
>> it could well now cause similar warnings in userspace programs.
>>
>> >  struct e820map {
>> > -   __u32 nr_map;
>> > +   __s32 nr_map;
>> >     struct e820entry map[E820_X_MAX];
>> >  };
>>
>> This number can't be negative!
>>
>
> Is this OK, or should I go more further:

since sanitize_e820_map does only modify its third argument on
success, and leaves it untouched on error, the temporary variable
could be eliminated in some places.

> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 23 Mar 2009 02:13:01 +0530
> Subject: [PATCH] x86: e820 fix various signedness issues in setup.c and e820.c
>
> Impact: cleanup
>
> This fixed various signedness issues in setup.c and e820.c:
> arch/x86/kernel/setup.c:455:53: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/setup.c:455:53:    expected int *pnr_map
> arch/x86/kernel/setup.c:455:53:    got unsigned int extern [toplevel] *<noident>
> arch/x86/kernel/setup.c:639:53: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/setup.c:639:53:    expected int *pnr_map
> arch/x86/kernel/setup.c:639:53:    got unsigned int extern [toplevel] *<noident>
> arch/x86/kernel/setup.c:820:54: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/setup.c:820:54:    expected int *pnr_map
> arch/x86/kernel/setup.c:820:54:    got unsigned int extern [toplevel] *<noident>
>
> arch/x86/kernel/e820.c:670:53: warning: incorrect type in argument 3 (different signedness)
> arch/x86/kernel/e820.c:670:53:    expected int *pnr_map
> arch/x86/kernel/e820.c:670:53:    got unsigned int [toplevel] *<noident>
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/e820.h |    2 +-
>  arch/x86/kernel/e820.c      |   10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index 00d41ce..7ecba4d 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -72,7 +72,7 @@ extern int e820_all_mapped(u64 start, u64 end, unsigned type);
>  extern void e820_add_region(u64 start, u64 size, int type);
>  extern void e820_print_map(char *who);
>  extern int
> -sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, int *pnr_map);
> +sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
>  extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
>                               unsigned new_type);
>  extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index fb638d9..ef2c356 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -233,7 +233,7 @@ void __init e820_print_map(char *who)
>  */
>
>  int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
> -                               int *pnr_map)
> +                            u32 *pnr_map)
>  {
>        struct change_member {
>                struct e820entry *pbios; /* pointer to original bios entry */
> @@ -552,7 +552,7 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
>
>  void __init update_e820(void)
>  {
> -       int nr_map;
> +       u32 nr_map;
>
>        nr_map = e820.nr_map;
>        if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
> @@ -563,7 +563,7 @@ void __init update_e820(void)
>  }
>  static void __init update_e820_saved(void)
>  {
> -       int nr_map;
> +       u32 nr_map;
>
>        nr_map = e820_saved.nr_map;
>        if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
> @@ -1303,7 +1303,7 @@ early_param("memmap", parse_memmap_opt);
>  void __init finish_e820_parsing(void)
>  {
>        if (userdef) {
> -               int nr = e820.nr_map;
> +               u32 nr = e820.nr_map;
>
>                if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
>                        early_panic("Invalid user supplied memory map");
> @@ -1386,7 +1386,7 @@ void __init e820_reserve_resources_late(void)
>  char *__init default_machine_specific_memory_setup(void)
>  {
>        char *who = "BIOS-e820";
> -       int new_nr;
> +       u32 new_nr;
>        /*
>         * Try to copy the BIOS-supplied E820-map.
>         *
> --
> 1.6.0.6
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
