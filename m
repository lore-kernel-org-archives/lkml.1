Return-Path: <linux-kernel-owner+w=401wt.eu-S933748AbXCKPVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbXCKPVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 11:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933749AbXCKPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 11:21:37 -0400
Received: from mxl144v76.mxlogic.net ([208.65.144.76]:35304 "EHLO
	p02c11o143.mxlogic.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933748AbXCKPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 11:21:36 -0400
Date: Sun, 11 Mar 2007 17:22:13 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Roland Dreier <roland.list@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!)
Message-ID: <20070311152213.GH31985@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <45E552FC.4040305@mellanox.co.il> <f8ca0a150703030937u61bcd9aj200415b76c00d151@mail.gmail.com> <20070311135051.GA31985@mellanox.co.il> <20070311150431.GE31985@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311150431.GE31985@mellanox.co.il>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 11 Mar 2007 15:24:27.0629 (UTC) FILETIME=[5B7941D0:01C763F1]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15044.001
X-TM-AS-Result: No--3.518300-4.000000-31
X-Spam: [F=0.3720686036; S=0.372(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [63.251.237.3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Michael S. Tsirkin <mst@mellanox.co.il>:
> Subject: Re: lockdep question (was Re: IPoIB caused a kernel: BUG: soft lockup detected on CPU#0!)
> 
> 
> After adding some printks, I started getting these:
> 
> [  597.036720] BUG: MAX_STACK_TRACE_ENTRIES too low!
> [  597.041546] turning off the locking correctness validator.

I looked at our stack usage a bit. It seems some work is in order.

$ make checkstack | grep ib_
0x00000603 mthca_init_hca [ib_mthca]:                   764
0x000014ed mthca_init_hca [ib_mthca]:                   764
0x000065ae ipoib_cm_tx_start [ib_ipoib]:                368
0x00006b0b ipoib_cm_tx_start [ib_ipoib]:                368
0x0000135f ib_uverbs_query_device [ib_uverbs]:          348
0x000015f9 ib_uverbs_query_device [ib_uverbs]:          348
0x000005d0 ib_ucm_init_qp_attr [ib_ucm]:                300
0x00000697 ib_ucm_init_qp_attr [ib_ucm]:                300
0x00007f9e ipoib_path_seq_show [ib_ipoib]:              264
0x00008092 ipoib_path_seq_show [ib_ipoib]:              264
0x00005b56 ipoib_cm_rx_handler [ib_ipoib]:              220
0x00005eec ipoib_cm_rx_handler [ib_ipoib]:              220
0x00007934 ipoib_cm_tx_handler [ib_ipoib]:              208
0x00007ce0 ipoib_cm_tx_handler [ib_ipoib]:              208
0x000032fe ib_uverbs_create_qp [ib_uverbs]:             192
0x000036fd ib_uverbs_create_qp [ib_uverbs]:             192
0x000028a9 srp_reset_host [ib_srp]:                     192
0x00002a96 srp_reset_host [ib_srp]:                     192
0x00001c99 show_sys_image_guid [ib_core]:               188
0x00001d2b show_sys_image_guid [ib_core]:               188
0x000001f9 ib_sa_service_rec_callback [ib_sa]:          180
0x00000234 ib_sa_service_rec_callback [ib_sa]:          180
0x00001b3c path_rec_completion [ib_ipoib]:              180
0x00002020 path_rec_completion [ib_ipoib]:              180
0x000070cf ipoib_cm_handle_rx_wc [ib_ipoib]:            180
0x00007402 ipoib_cm_handle_rx_wc [ib_ipoib]:            180
0x000009a7 srp_create_target [ib_srp]:                  176
0x0000125f srp_create_target [ib_srp]:                  176
0x00000d9d ib_cm_listen [ib_cm]:                        172
0x000010b3 ib_cm_listen [ib_cm]:                        172
0x00004455 ipoib_mcast_send [ib_ipoib]:                 172
0x000048e0 ipoib_mcast_send [ib_ipoib]:                 172
0x000015c1 ipoib_start_xmit [ib_ipoib]:                 164
0x00001b2d ipoib_start_xmit [ib_ipoib]:                 164
0x000056c8 mthca_make_profile [ib_mthca]:               160
0x00006051 mthca_make_profile [ib_mthca]:               160
0x00002abb ipoib_ib_dev_stop [ib_ipoib]:                160
0x00002d19 ipoib_ib_dev_stop [ib_ipoib]:                160
0x0000202b ib_uverbs_query_qp [ib_uverbs]:              156
0x000022c0 ib_uverbs_query_qp [ib_uverbs]:              156
0x00005269 ipoib_init_qp [ib_ipoib]:                    152
0x000053bc ipoib_init_qp [ib_ipoib]:                    152
0x0000327f ipoib_mcast_join [ib_ipoib]:                 144
0x0000349d ipoib_mcast_join [ib_ipoib]:                 144
0x00002092 ib_find_send_mad [ib_mad]:                   140
0x000023fa ib_find_send_mad [ib_mad]:                   140
0x000022cf ib_uverbs_modify_qp [ib_uverbs]:             140
0x000024f2 ib_uverbs_modify_qp [ib_uverbs]:             140
0x0000bc8e mthca_modify_qp [ib_mthca]:                  136
0x0000c9cc mthca_modify_qp [ib_mthca]:                  136
0x00010cb1 mthca_reg_phys_mr [ib_mthca]:                136
0x0001117a mthca_reg_phys_mr [ib_mthca]:                136
0x000035b4 ipoib_mcast_join_finish [ib_ipoib]:          136
0x00003a33 ipoib_mcast_join_finish [ib_ipoib]:          136
0x00000793 iser_cma_handler [ib_iser]:                  132
0x00000bc1 iser_cma_handler [ib_iser]:                  132
0x00001e37 srp_queuecommand [ib_srp]:                   132
0x0000273b srp_queuecommand [ib_srp]:                   132
0x00008a5a mthca_poll_cq [ib_mthca]:                    128
0x00009204 mthca_poll_cq [ib_mthca]:                    128
0x00003a42 ipoib_mcast_join_complete [ib_ipoib]:        128
0x00003e6e ipoib_mcast_join_complete [ib_ipoib]:        128
0x00004a58 ipoib_mcast_restart_task [ib_ipoib]:         128
0x00004eb8 ipoib_mcast_restart_task [ib_ipoib]:         128
0x000038e6 ib_uverbs_create_ah [ib_uverbs]:             116
0x00003ac4 ib_uverbs_create_ah [ib_uverbs]:             116
0x0000f6a5 mthca_process_mad [ib_mthca]:                116
0x0000fa93 mthca_process_mad [ib_mthca]:                116
0x000011ef mcast_work_handler [ib_sa]:                  112
0x000016e6 mcast_work_handler [ib_sa]:                  112
0x00000a20 ib_ucm_send_req [ib_ucm]:                    112
0x00000b7c ib_ucm_send_req [ib_ucm]:                    112
0x00001697 ib_post_send_mad [ib_mad]:                   112
0x00001b05 ib_post_send_mad [ib_mad]:                   112
0x0000030e iser_post_send [ib_iser]:                    112
0x000003c5 iser_post_send [ib_iser]:                    112
0x00001605 ib_uverbs_query_port [ib_uverbs]:            108
0x00001713 ib_uverbs_query_port [ib_uverbs]:            108
0x0000171d ib_uverbs_create_srq [ib_uverbs]:            108
0x00001946 ib_uverbs_create_srq [ib_uverbs]:            108
0x00002409 ib_mad_completion_handler [ib_mad]:          104
0x00002907 ib_mad_completion_handler [ib_mad]:          104
0x00002454 iser_reg_rdma_mem [ib_iser]:                 104
0x00002aa8 iser_reg_rdma_mem [ib_iser]:                 104
0x0416 rdma_resolve_ip [ib_addr]:                       100
0x066f rdma_resolve_ip [ib_addr]:                       100
0x00007dcb ipoib_mcg_seq_show [ib_ipoib]:               100
0x00007e65 ipoib_mcg_seq_show [ib_ipoib]:               100


-- 
MST
