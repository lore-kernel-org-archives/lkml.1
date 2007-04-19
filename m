Return-Path: <linux-kernel-owner+w=401wt.eu-S2993203AbXDSJFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993203AbXDSJFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993211AbXDSJFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:05:32 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:49420 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161474AbXDSJFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:05:30 -0400
Subject: Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070419070437.GA25211@elte.hu>
References: <20070413202100.GA9957@elte.hu>
	 <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <1176947576.5906.21.camel@nigel.suspend2.net>
	 <20070419070437.GA25211@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SUwetG308I8zp4rYLXX9"
Date: Thu, 19 Apr 2007 19:05:25 +1000
Message-Id: <1176973526.4002.51.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SUwetG308I8zp4rYLXX9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ingo.

On Thu, 2007-04-19 at 09:04 +0200, Ingo Molnar wrote:
> * Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
>=20
> > From subsequent emails, I think you already got your answer, but just=20
> > in case...
> >=20
> > Yes, if you enabled "Replace swsusp by default" and you already had it=20
> > set up for getting swsusp to resume. If not, and you're using an=20
> > initrd/ramfs, you'll need to modify it to echo
> > > /sys/power/suspend2/do_resume after /sys and /proc are mounted but
> > prior to mounting / and so on.
>=20
> yeah, went with the default suggested by your patch:
>=20
>    CONFIG_SUSPEND2_REPLACE_SWSUSP=3Dy
>=20
> and it was pretty easy to set things up. I used "echo disk >=20
> /sys/power/state" to trigger it.
>=20
> In hindsight it was all pretty straightforward and suspend2 worked=20
> beautifully on an UP and on an SMP system i tried. So in exchange for=20
> suspend2 folks debugging a bug in CFS here's some suspend2 review=20
> feedback ;) Any plans about moving suspend2 to the upstream kernel? It=20
> should be pretty easy for it to co-exist with the current swsuspend=20
> code.

I really would like to get it into Linus' tree but Pavel doesn't want it
(obviously!) and I haven't got together enough of a case yet to convince
Andrew. I yet another here's-why-I-think-it-should-be-merged email in
the works (poor Andrew!) but there are too many other things on my plate
at the mo.

> The patch has quite some size:
>=20
>  89 files changed, 16452 insertions(+), 69 deletions(-)
>=20
> that should obviously be split up into more than a dozen sub-patches,=20
> and fed to lkml with the small ones first. (unless it already is split=20
> up?)

Right. A good portion (~2000 lines) of that is documentation.

> i cannot comment on the kernel/power/ bits (they are way too large=20
> anyway), other than that they look pretty clean visually, but the=20
> lowlevel arch and generic kernel bits look sane in detail too, sans a=20
> few mostly trivial cleanliness issues:
>=20
> +int suspend2_faulted =3D 0;
> +EXPORT_SYMBOL(suspend2_faulted);
>=20
> should be done via the pagefault notifier chain mechanism. Also, all the=20
> exports you added should be EXPORT_SYMBOL_GPL().

I'll look at that, but I'm not sure if it's a good idea - this is for
during the atomic copy & restore, when DEBUG_PAGEALLOC is enabled on
x86. Other things might touch memory in ways we don't want. It's only
needed for slab pages that get unmapped but not freed.

As far as the module exports go, I'm not expecting them to get merged. I
like building Suspend2 as modules (it helps speed the development
cycle), and see it as potentially useful for embedded but IMO there are
too many export symbols to make merging that code a possibility. This is
why they're all in one file rather than sprinkled through the files that
define the symbols.

> this:
>=20
> -               ClearPageReserved(virt_to_page(addr));
> -               init_page_count(virt_to_page(addr));
> +               //ClearPageReserved(virt_to_page(addr));
> +               //init_page_count(virt_to_page(addr));
>=20
> looks like there's a buglet in there still somewhere?

Yeah. When I was recently debugging, I found that cpu hotplugging is
using something marked __init which is causing the machine to
spontaneously reboot when cpus are replugged if DEBUG_PAGEALLOC is
enabled. Haven't had the time to get back to it, and also need some help
with the approach (what makes the machine reboot in this case instead of
oopsing, and how do I stop it?).

> +       if(PageHighMem(page))
> +               return 0;
>=20
> coding style.

Oh. The space missing after the if? Ok.

> +       BUG_ON( test_suspend_state(SUSPEND_RUNNING) &&  /* Suspend2, that=
 is */
>=20
> make this a WARN_ON() or a WARN_ON_ONCE() - that way you have a chance=20
> to even get feedback from users, instead of a 'uhm, X froze' report.
>=20
> +#define FREEZER_OFF 0
> +#define FREEZER_USERSPACE_FROZEN 1
> +#define FREEZER_FULLY_ON 2
>=20
> should be:
>=20
> +#define FREEZER_OFF			0
> +#define FREEZER_USERSPACE_FROZEN	1
> +#define FREEZER_FULLY_ON		2
>=20
> (you want your reviewers have an pleasant time reading your code :)

Ok.

> +#define NETLINK_SUSPEND2_USERUI        20      /* For suspend2's userui =
*/
>=20
> IIRC userui was at the center of suspend2 merge flames, right? So you=20
> might want to layer it ontop a less flashy suspend2-core and thus get=20
> 90% of your patch upstream?

Ok. I've just separated that into it's own file/module, so that will be
straightforward to do.

> +++ linux/mm/vmscan.c
>=20
> the MM impact looks quite nontrivial. But i suspect this is unavoidable,=20
> because you zap portions of the pagecache on the way to disk, so when it=20
> comes back it results in a different pagecache (new lru lists, etc.),=20
> right?

The modifications do three things.

First, we're seeking to keep the LRU static once while we're suspending.
I originally sought to achieve that by avoiding entering the vmscan.c
logic (not as drastic as it sounds - Suspend2 is the only thing
running!). I think it was Nick who said he'd rather see it the pages
unlinked and kept safe that way, so now I do that. Oh, as part of this,
I separated out the code from shrink_inactive_list that returns isolated
pages, since relink_lru_lists uses it too.

The other part is (prior to the above) seeking to get in a situation
where we have enough memory available to do the cycle. I used to use
shrink_all_zones, but some users with lots of Highmem were finding
issues that let me to take a more per-zone based approach, hence
shrink_one_zone.

The last thing is a patch Rafael recently posted to improve kswapd
freezing.

> +++ linux/lib/dyn_pageflags.c
>=20
> shouldnt this be in mm/dyn_pageflags.c? Plus it would be nice to use=20
> some other core kernel user for this infrastructure. (but it's not a=20
> necessity i guess)

Yeah, I guess mm makes more sense.

> but ... again, the patch looks sane all around.

Thanks for the feedback. Although I'd like to see Suspend2 merged, I've
been feeling a bit like it's a lost cause. It's nice to get some
encouragement.

Nigel

--=-SUwetG308I8zp4rYLXX9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJzDVN0y+n1M3mo0RAux1AKCRIune/t/iuoLWkMiyVfhFH9X19wCghK4V
oNv5pZpbUCkqwy06YX/m2Rc=
=4TUv
-----END PGP SIGNATURE-----

--=-SUwetG308I8zp4rYLXX9--

