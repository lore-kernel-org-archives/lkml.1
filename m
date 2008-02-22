Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYBVQW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYBVQW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbYBVQWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:22:49 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56664 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbYBVQWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:22:48 -0500
Date: Fri, 22 Feb 2008 10:22:03 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] capabilities: implement per-process securebits
Message-ID: <20080222162203.GA4223@sergelap.austin.ibm.com>
References: <47BA3E21.2020303@kernel.org> <20080220174252.GA16304@sergelap.austin.ibm.com> <47BE2C6F.9090504@kernel.org> <47BE6782.2020604@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BE6782.2020604@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
>
> Andrew G. Morgan wrote:
> | Serge E. Hallyn wrote:
> | |> It all looks good to me.
> | |
> | |> Since we've confirmed that wireshark uses capabilities it must be 
> using
> | |> prctl(PR_SET_KEEPCAPS), so running it might be a good way to verify
> that
> | |> your changes to that codepath (with
> CONFIG_SECURITY_FILE_CAPABILITIES=n)
> | |> are 100% correct, and might set minds at ease.  Is that something
> you're
> | |> set up to be able to do?
> |
> | I guess I need someone to offer an existence proof that this particular
> | wireshark code ever worked? (ldd dumpcap|grep libcap). For reference,
> | I'm looking at:
>
> Doh! :*)
>
> I had mistaken cap_init() for cap_get_proc() in the wireshark code...
>
> I now see what wireshark is trying to do, and can *confirm* that with
> the present patch I do maintain the legacy behavior. :-)

Cool, thanks!

> FWIW I've updated capsh in the libcap git tree to add a few more hooks
> and with the following sequence can now verify that the keep-caps works
> as before:
>
> As root:
> # rm -f tcapsh
> # cp capsh tcapsh
> # chown root.root tcapsh
> # chmod u+s tcapsh
> # ls -l tcapsh
> # ./capsh --uid=500 -- -c "./tcapsh --keep=1 \
> ~  --caps=\"cap_net_raw,cap_net_admin=ip\" --uid=500 \
> ~  --caps=\"cap_net_raw,cap_net_admin=pie\" --print"
> # echo $?
> 0
>
> The wireshark problem, that you have been discussing (in the other
> thread), can also be simulated as follows:
>
> # ./capsh --uid=500 -- -c "./tcapsh --keep=1 \
> ~  --caps=\"cap_net_raw,cap_net_admin=ip\" \
> ~  --uid=500 --forkfor=10 --caps= --print \
> ~  --killit=9 --print"
>
> You might like to re-post your fix for that problem as a stand alone
> patch; I suspect it may be lost in the noise at this point. (You might
> also like to update the comment in that fix since the old comment looks
> very stale if you delete the ->euid==0 check. I think it is safe to
> simply say /* legacy signal behavior requires that a user can kill any
> process running with their uid */)

I did resend it on Wednesday and add the comment that

'Without this patch wireshark is reported to fail.'

I'll resend explicitly to Linus and add your comment change on monday
if it's not upstream yet.  (Will be offline this weekend).

thanks,
-serge

>
> Cheers
>
> Andrew
>
> |
> | wireshark-0.99.7/dumpcap.c:302
> |
> | void
> | relinquish_privs_except_capture(void)
> | {
> | ~    /* CAP_NET_ADMIN: Promiscuous mode and a truckload of other
> | ~     *                stuff we don't need (and shouldn't have).
> | ~     * CAP_NET_RAW:   Packet capture (raw sockets).
> | ~     */
> | ~    cap_value_t cap_list[2] = { CAP_NET_ADMIN, CAP_NET_RAW };
> | ~    cap_t caps = cap_init();
> | ~    int cl_len = sizeof(cap_list) / sizeof(cap_value_t);
> |
> | ~    if (started_with_special_privs()) {
> | ~        print_caps("Pre drop, pre set");
> | ~        if (prctl(PR_SET_KEEPCAPS, 1, 0, 0, 0) == -1) {
> | ~            perror("prctl()");
> | ~        }
> |
> | ~        cap_set_flag(caps, CAP_PERMITTED,   cl_len, cap_list, CAP_SET);
> | ~        cap_set_flag(caps, CAP_INHERITABLE, cl_len, cap_list, CAP_SET);
> |
> | [ XXX:AGM since (caps.pE > caps.pP) this next line should fail ]
> | ~        if (cap_set_proc(caps)) {
> | ~            perror("capset()");
> | ~        }
> | ~        print_caps("Pre drop, post set");
> | ~    }
> |
> | ~    relinquish_special_privs_perm();
> |
> | ~    print_caps("Post drop, pre set");
> | ~    cap_set_flag(caps, CAP_EFFECTIVE,   cl_len, cap_list, CAP_SET);
> | ~    if (cap_set_proc(caps)) {
> | ~        perror("capset()");
> | ~    }
> | ~    print_caps("Post drop, post set");
> | ~    cap_free(caps);
> | }
> | #endif /* HAVE_LIBCAP */
> |
> | My reading of the above code suggests that the application believes that
> | it can raise/retain effective capabilities that are not in its permitted
> | set.
> |
> | Browsing back in my git tree all the way back to 'v2.6.12-rc2', the
> | following code (cap_capset_check) correctly requires:
> |
> | ~   96  /* verify the _new_Effective_ is a subset of the
> _new_Permitted_ */
> | ~   97  if (!cap_issubset (*effective, *permitted)) {
> | ~   98   return -EPERM;
> | ~   99  }
> |
> | so my question is, why should one expect this wireshark code to work? It
> | looks wrong to me.
> |
> | Thanks
> |
> | Andrew
> |
> | |
> | |> -serge
> | |
> | | Thanks
> | |
> | | Andrew
> |
> | ~From 006ddf6903983dd596e360ab1ab8e537b29fab46 Mon Sep 17 00:00:00 2001
> | From: Andrew G. Morgan <morgan@kernel.org>
> | Date: Mon, 18 Feb 2008 15:23:28 -0800
> | Subject: [PATCH] Implement per-process securebits
> | |>
> | [This patch represents a no-op unless CONFIG_SECURITY_FILE_CAPABILITIES
> | ~ is enabled at configure time.]
> | |>
> | Filesystem capability support makes it possible to do away with
> | (set)uid-0 based privilege and use capabilities instead. That is, with
> | filesystem support for capabilities but without this present patch,
> | it is (conceptually) possible to manage a system with capabilities
> | alone and never need to obtain privilege via (set)uid-0.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFHvmeB+bHCR3gb8jsRAknmAKCMw0Qe7uDwtuRE+f3YVmnlE5pK4wCgsv0f
> 5E6+K9Z0Xp1P74iOlnt221o=
> =+sLL
> -----END PGP SIGNATURE-----
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
