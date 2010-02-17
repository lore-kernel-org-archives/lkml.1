Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0BQUWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:22:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:34766 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0BQUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:22:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KjlCR8Cxw9eoS8cACkfzDWfrVrSDu8PZtTcQIlO+LeniDOUWzGJvvSH+NWilPYPiqC
         I35k/uygkgiEO5D3DuVlLXhoL20u6ifloCt+JGaVVKpOwLXwcaexvakF25aScc+xFkZb
         k9q5XGySCwMrANZXlzWSZgZOqU4KFmd1z9Whk=
Date: Wed, 17 Feb 2010 22:22:34 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: hang in call_usermodehelper_exec()
Message-ID: <20100217202234.GD5256@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was stress-testing netns stuff in presence of removing modules.

Kernel is 2.6.33-rc8-next-20100217+:

At some point setkey(8) and modprobe hanged:

3541 pts/1    D      0:00 /usr/sbin/setkey -f /root/ipcomp-tunnel.setkey
3737 pts/2    D      0:00 modprobe -r des_generic sha1_generic md5 hmac xfrm_user crypto_null af_packet xfrm4_mode_beet ipcomp xfrm_ipcomp  xfrm4_tunnel deflate zlib_deflate zlib_inflate esp4 xfrm4_mode_tran

SysRq : Show Blocked State
  task                        PC stack   pid father
ipcomp-tunnel D 0000000000000000  4944  3541   3532 0x00000000
 ffff8800b98636f8 0000000000000046 0000000000000082 ffff8800b9862000
 ffff8800b9863fd8 ffff8800b9862000 0000000000004000 ffff8800b9863fd8
 ffff8800b9863fd8 ffff8800bd40eba0 ffffffff81625020 0000000000000046
Call Trace:
 [<ffffffff813f218d>] schedule_timeout+0x2ad/0x320
 [<ffffffff813f1239>] ? wait_for_common+0x49/0x180
 [<ffffffff813f134b>] wait_for_common+0x15b/0x180
 [<ffffffff81038960>] ? default_wake_function+0x0/0x20
 [<ffffffff813f142d>] wait_for_completion+0x1d/0x20
 [<ffffffff8105c841>] call_usermodehelper_exec+0xe1/0x110
 [<ffffffff813ddaf0>] ? xfrm_init_state+0x120/0x3a0
 [<ffffffff8105cb24>] __request_module+0x194/0x200
 [<ffffffff81060568>] ? __kernel_text_address+0x58/0x80
 [<ffffffff813dd68c>] ? xfrm_state_get_afinfo+0x2c/0x60
 [<ffffffff813ddaf0>] xfrm_init_state+0x120/0x3a0
 [<ffffffff810e7bbe>] ? kmem_cache_alloc_notrace+0xbe/0x130
 [<ffffffffa05750e8>] pfkey_add+0x738/0x980 [af_key]
 [<ffffffffa0570b86>] ? pfkey_broadcast+0x1e6/0x210 [af_key]
 [<ffffffffa05709a0>] ? pfkey_broadcast+0x0/0x210 [af_key]
 [<ffffffff8136b90e>] ? __skb_clone+0x2e/0x110
 [<ffffffffa0573655>] pfkey_sendmsg+0x375/0x3b0 [af_key]
 [<ffffffff81364a60>] sock_sendmsg+0xc0/0xf0
 [<ffffffff81364b1a>] ? sockfd_lookup_light+0x2a/0x80
 [<ffffffff8136532f>] sys_sendto+0xef/0x120
 [<ffffffff813681c4>] ? release_sock+0x34/0x110
 [<ffffffff8136828b>] ? release_sock+0xfb/0x110
 [<ffffffff8136a30b>] ? sock_setsockopt+0xcb/0x850
 [<ffffffff810d4176>] ? remove_vma+0x66/0x80
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
modprobe      D ffff8800bd072ba0  5280  3737   3734 0x00000000
 ffff8800b9ae1ed8 0000000000000046 0000000000000000 ffff8800b9ae0000
 ffff8800b9ae1fd8 ffff8800b9ae0000 0000000000004000 ffff8800b9ae1fd8
 ffff8800b9ae1fd8 ffff8800b98bae20 ffff8800bad4dc40 ffffffff81630f68
Call Trace:
 [<ffffffff810761dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81083306>] ? module_refcount+0x46/0xb0
 [<ffffffff81084150>] sys_delete_module+0x230/0x250
 [<ffffffff813f4522>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: task ipcomp-tunnel.s:3541 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ipcomp-tunnel D 0000000000000000  4944  3541   3532 0x00000000
 ffff8800b98636f8 0000000000000046 0000000000000082 ffff8800b9862000
 ffff8800b9863fd8 ffff8800b9862000 0000000000004000 ffff8800b9863fd8
 ffff8800b9863fd8 ffff8800bd40eba0 ffffffff81625020 0000000000000046
Call Trace:
 [<ffffffff813f218d>] schedule_timeout+0x2ad/0x320
 [<ffffffff813f1239>] ? wait_for_common+0x49/0x180
 [<ffffffff813f134b>] wait_for_common+0x15b/0x180
 [<ffffffff81038960>] ? default_wake_function+0x0/0x20
 [<ffffffff813f142d>] wait_for_completion+0x1d/0x20
 [<ffffffff8105c841>] call_usermodehelper_exec+0xe1/0x110
 [<ffffffff813ddaf0>] ? xfrm_init_state+0x120/0x3a0
 [<ffffffff8105cb24>] __request_module+0x194/0x200
 [<ffffffff81060568>] ? __kernel_text_address+0x58/0x80
 [<ffffffff813dd68c>] ? xfrm_state_get_afinfo+0x2c/0x60
 [<ffffffff813ddaf0>] xfrm_init_state+0x120/0x3a0
 [<ffffffff810e7bbe>] ? kmem_cache_alloc_notrace+0xbe/0x130
 [<ffffffffa05750e8>] pfkey_add+0x738/0x980 [af_key]
 [<ffffffffa0570b86>] ? pfkey_broadcast+0x1e6/0x210 [af_key]
 [<ffffffffa05709a0>] ? pfkey_broadcast+0x0/0x210 [af_key]
 [<ffffffff8136b90e>] ? __skb_clone+0x2e/0x110
 [<ffffffffa0573655>] pfkey_sendmsg+0x375/0x3b0 [af_key]
 [<ffffffff81364a60>] sock_sendmsg+0xc0/0xf0
 [<ffffffff81364b1a>] ? sockfd_lookup_light+0x2a/0x80
 [<ffffffff8136532f>] sys_sendto+0xef/0x120
 [<ffffffff813681c4>] ? release_sock+0x34/0x110
 [<ffffffff8136828b>] ? release_sock+0xfb/0x110
 [<ffffffff8136a30b>] ? sock_setsockopt+0xcb/0x850
 [<ffffffff810d4176>] ? remove_vma+0x66/0x80
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task modprobe:3737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D ffff8800bd072ba0  5280  3737   3734 0x00000000
 ffff8800b9ae1ed8 0000000000000046 0000000000000000 ffff8800b9ae0000
 ffff8800b9ae1fd8 ffff8800b9ae0000 0000000000004000 ffff8800b9ae1fd8
 ffff8800b9ae1fd8 ffff8800b98bae20 ffff8800bad4dc40 ffffffff81630f68
Call Trace:
 [<ffffffff810761dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81083306>] ? module_refcount+0x46/0xb0
 [<ffffffff81084150>] sys_delete_module+0x230/0x250
 [<ffffffff813f4522>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task ipcomp-tunnel.s:3541 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ipcomp-tunnel D 0000000000000000  4944  3541   3532 0x00000000
 ffff8800b98636f8 0000000000000046 0000000000000082 ffff8800b9862000
 ffff8800b9863fd8 ffff8800b9862000 0000000000004000 ffff8800b9863fd8
 ffff8800b9863fd8 ffff8800bd40eba0 ffffffff81625020 0000000000000046
Call Trace:
 [<ffffffff813f218d>] schedule_timeout+0x2ad/0x320
 [<ffffffff813f1239>] ? wait_for_common+0x49/0x180
 [<ffffffff813f134b>] wait_for_common+0x15b/0x180
 [<ffffffff81038960>] ? default_wake_function+0x0/0x20
 [<ffffffff813f142d>] wait_for_completion+0x1d/0x20
 [<ffffffff8105c841>] call_usermodehelper_exec+0xe1/0x110
 [<ffffffff813ddaf0>] ? xfrm_init_state+0x120/0x3a0
 [<ffffffff8105cb24>] __request_module+0x194/0x200
 [<ffffffff81060568>] ? __kernel_text_address+0x58/0x80
 [<ffffffff813dd68c>] ? xfrm_state_get_afinfo+0x2c/0x60
 [<ffffffff813ddaf0>] xfrm_init_state+0x120/0x3a0
 [<ffffffff810e7bbe>] ? kmem_cache_alloc_notrace+0xbe/0x130
 [<ffffffffa05750e8>] pfkey_add+0x738/0x980 [af_key]
 [<ffffffffa0570b86>] ? pfkey_broadcast+0x1e6/0x210 [af_key]
 [<ffffffffa05709a0>] ? pfkey_broadcast+0x0/0x210 [af_key]
 [<ffffffff8136b90e>] ? __skb_clone+0x2e/0x110
 [<ffffffffa0573655>] pfkey_sendmsg+0x375/0x3b0 [af_key]
 [<ffffffff81364a60>] sock_sendmsg+0xc0/0xf0
 [<ffffffff81364b1a>] ? sockfd_lookup_light+0x2a/0x80
 [<ffffffff8136532f>] sys_sendto+0xef/0x120
 [<ffffffff813681c4>] ? release_sock+0x34/0x110
 [<ffffffff8136828b>] ? release_sock+0xfb/0x110
 [<ffffffff8136a30b>] ? sock_setsockopt+0xcb/0x850
 [<ffffffff810d4176>] ? remove_vma+0x66/0x80
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task modprobe:3737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D ffff8800bd072ba0  5280  3737   3734 0x00000000
 ffff8800b9ae1ed8 0000000000000046 0000000000000000 ffff8800b9ae0000
 ffff8800b9ae1fd8 ffff8800b9ae0000 0000000000004000 ffff8800b9ae1fd8
 ffff8800b9ae1fd8 ffff8800b98bae20 ffff8800bad4dc40 ffffffff81630f68
Call Trace:
 [<ffffffff810761dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81083306>] ? module_refcount+0x46/0xb0
 [<ffffffff81084150>] sys_delete_module+0x230/0x250
 [<ffffffff813f4522>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task ipcomp-tunnel.s:3541 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ipcomp-tunnel D 0000000000000000  4944  3541   3532 0x00000000
 ffff8800b98636f8 0000000000000046 0000000000000082 ffff8800b9862000
 ffff8800b9863fd8 ffff8800b9862000 0000000000004000 ffff8800b9863fd8
 ffff8800b9863fd8 ffff8800bd40eba0 ffffffff81625020 0000000000000046
Call Trace:
 [<ffffffff813f218d>] schedule_timeout+0x2ad/0x320
 [<ffffffff813f1239>] ? wait_for_common+0x49/0x180
 [<ffffffff813f134b>] wait_for_common+0x15b/0x180
 [<ffffffff81038960>] ? default_wake_function+0x0/0x20
 [<ffffffff813f142d>] wait_for_completion+0x1d/0x20
 [<ffffffff8105c841>] call_usermodehelper_exec+0xe1/0x110
 [<ffffffff813ddaf0>] ? xfrm_init_state+0x120/0x3a0
 [<ffffffff8105cb24>] __request_module+0x194/0x200
 [<ffffffff81060568>] ? __kernel_text_address+0x58/0x80
 [<ffffffff813dd68c>] ? xfrm_state_get_afinfo+0x2c/0x60
 [<ffffffff813ddaf0>] xfrm_init_state+0x120/0x3a0
 [<ffffffff810e7bbe>] ? kmem_cache_alloc_notrace+0xbe/0x130
 [<ffffffffa05750e8>] pfkey_add+0x738/0x980 [af_key]
 [<ffffffffa0570b86>] ? pfkey_broadcast+0x1e6/0x210 [af_key]
 [<ffffffffa05709a0>] ? pfkey_broadcast+0x0/0x210 [af_key]
 [<ffffffff8136b90e>] ? __skb_clone+0x2e/0x110
 [<ffffffffa0573655>] pfkey_sendmsg+0x375/0x3b0 [af_key]
 [<ffffffff81364a60>] sock_sendmsg+0xc0/0xf0
 [<ffffffff81364b1a>] ? sockfd_lookup_light+0x2a/0x80
 [<ffffffff8136532f>] sys_sendto+0xef/0x120
 [<ffffffff813681c4>] ? release_sock+0x34/0x110
 [<ffffffff8136828b>] ? release_sock+0xfb/0x110
 [<ffffffff8136a30b>] ? sock_setsockopt+0xcb/0x850
 [<ffffffff810d4176>] ? remove_vma+0x66/0x80
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task modprobe:3737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D ffff8800bd072ba0  5280  3737   3734 0x00000000
 ffff8800b9ae1ed8 0000000000000046 0000000000000000 ffff8800b9ae0000
 ffff8800b9ae1fd8 ffff8800b9ae0000 0000000000004000 ffff8800b9ae1fd8
 ffff8800b9ae1fd8 ffff8800b98bae20 ffff8800bad4dc40 ffffffff81630f68
Call Trace:
 [<ffffffff810761dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81083306>] ? module_refcount+0x46/0xb0
 [<ffffffff81084150>] sys_delete_module+0x230/0x250
 [<ffffffff813f4522>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task ipcomp-tunnel.s:3541 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ipcomp-tunnel D 0000000000000000  4944  3541   3532 0x00000000
 ffff8800b98636f8 0000000000000046 0000000000000082 ffff8800b9862000
 ffff8800b9863fd8 ffff8800b9862000 0000000000004000 ffff8800b9863fd8
 ffff8800b9863fd8 ffff8800bd40eba0 ffffffff81625020 0000000000000046
Call Trace:
 [<ffffffff813f218d>] schedule_timeout+0x2ad/0x320
 [<ffffffff813f1239>] ? wait_for_common+0x49/0x180
 [<ffffffff813f134b>] wait_for_common+0x15b/0x180
 [<ffffffff81038960>] ? default_wake_function+0x0/0x20
 [<ffffffff813f142d>] wait_for_completion+0x1d/0x20
 [<ffffffff8105c841>] call_usermodehelper_exec+0xe1/0x110
 [<ffffffff813ddaf0>] ? xfrm_init_state+0x120/0x3a0
 [<ffffffff8105cb24>] __request_module+0x194/0x200
 [<ffffffff81060568>] ? __kernel_text_address+0x58/0x80
 [<ffffffff813dd68c>] ? xfrm_state_get_afinfo+0x2c/0x60
 [<ffffffff813ddaf0>] xfrm_init_state+0x120/0x3a0
 [<ffffffff810e7bbe>] ? kmem_cache_alloc_notrace+0xbe/0x130
 [<ffffffffa05750e8>] pfkey_add+0x738/0x980 [af_key]
 [<ffffffffa0570b86>] ? pfkey_broadcast+0x1e6/0x210 [af_key]
 [<ffffffffa05709a0>] ? pfkey_broadcast+0x0/0x210 [af_key]
 [<ffffffff8136b90e>] ? __skb_clone+0x2e/0x110
 [<ffffffffa0573655>] pfkey_sendmsg+0x375/0x3b0 [af_key]
 [<ffffffff81364a60>] sock_sendmsg+0xc0/0xf0
 [<ffffffff81364b1a>] ? sockfd_lookup_light+0x2a/0x80
 [<ffffffff8136532f>] sys_sendto+0xef/0x120
 [<ffffffff813681c4>] ? release_sock+0x34/0x110
 [<ffffffff8136828b>] ? release_sock+0xfb/0x110
 [<ffffffff8136a30b>] ? sock_setsockopt+0xcb/0x850
 [<ffffffff810d4176>] ? remove_vma+0x66/0x80
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
INFO: task modprobe:3737 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D ffff8800bd072ba0  5280  3737   3734 0x00000000
 ffff8800b9ae1ed8 0000000000000046 0000000000000000 ffff8800b9ae0000
 ffff8800b9ae1fd8 ffff8800b9ae0000 0000000000004000 ffff8800b9ae1fd8
 ffff8800b9ae1fd8 ffff8800b98bae20 ffff8800bad4dc40 ffffffff81630f68
Call Trace:
 [<ffffffff810761dd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81083306>] ? module_refcount+0x46/0xb0
 [<ffffffff81084150>] sys_delete_module+0x230/0x250
 [<ffffffff813f4522>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100279b>] system_call_fastpath+0x16/0x1b
INFO: lockdep is turned off.
