Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYL1IBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYL1IBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 03:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYL1IB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 03:01:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42192
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbYL1IBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 03:01:18 -0500
Date: Sun, 28 Dec 2008 00:01:18 -0800 (PST)
Message-Id: <20081228.000118.121541932.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBS82Jki019142


Here are the pending networking changes for the 2.6.29 merge window.

A lot of what you see follows the usual boiler plate.  A driver
maintainer making a lot of changes to driver FOO.  Similarly for
maintainers of networking protocols.  Another person does a series of
similar sparse warning fixes, etc.

And of course my list of changes is largely composed of merges.

But here are the interesting other changes in here:

1) Socket hashes converted to RCU locking by Eric Dumazet.
   Some really excellent stuff, and he's also done some
   things to help out socket open/close scalability.  Eric
   also has some VFS layer changes under review with the
   VFS folks to make that area even better.

2) Harvey Harrison has added some new %pX formatting handlers
   for ethernet MAC addresses, ipv4 addresses, and ipv6 addresses.

3) Alexey Dobriyan, Benjamin Thery, Daniel Lezcano, and
   Eric W. Biederman have made more large strides in namespace
   support for networking.

4) Stephen Hemminger has started the long laborious but useful	
   process of seperating the driver callbacks out of the
   network device struct.  All unconverted drivers still work
   just fine during this transition period, at pretty much no
   cost to the fast paths.

5) Ilpo JÃ¤rvinen implemented resegmentation for the retransmit
   queue.  This is a very powerful operation which cures the most
   expensive aspects during fast recovery after a loss.  In such
   cases we have to hold onto an entire window of data, and if
   that window is very large then when the missing chunk gets
   filled in we loop for a long time freeing tons of SKBs.

   So as the SACK information advances the edge of packets
   received in order, we can coalesce these portions back into
   one large TSO'ish SKB.  As a result, when the missing piece
   of the window is filled in, we do only a small number of
   SKB frees.  It basically divides the work more evenly over
   the process of recovery.

6) Wang Chen went through the entire tree and made sure every
   networking driver uses netdev_priv() to get at the driver
   private.  And as a result we could eliminate the struct netdev
   "priv" member entirely.

   This set of changes helped spot a few bugs and driver private
   memory lifetime issues.

7) Benchmarks over loopback hit the dev->last_rx shared data real
   hard on SMP boxes.  This jiffies state is only used by bonding,
   so we've rearranged things such that only the bonding path even
   tries to set this thing.

   This work was done by Jay Vosburgh.

Please pull, thanks a lot!

The following changes since commit 4a6908a3a050aacc9c3a2f36b276b46c0629ad91:
  Linus Torvalds (1):
        Linux 2.6.28

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Abbas, Mohamed (3):
      iwl3945: add debugfs support
      iwl3945: Fix iwl3945 rate scaling.
      iwl3945: Fix rate scale for B-mode connection

Abhijeet Kolekar (3):
      iwlwifi : fix checkpatch.pl errors
      iwl3945 : Fix ad-hoc mode for 3945
      iwl3945 : Fix a-band association for passive channels

Adrian Bunk (1):
      The overdue eepro100 removal.

Al Viro (1):
      ixgbe: section fixes

Alan Cox (2):
      tty: Flags should be accessed via the foo_bit interfaces
      tty: driverdata and discdata are void *

Alexander Duyck (20):
      e1000e: enable ECC correction on 82571 silicon
      igb: update name to reflect new hardware
      igb: simplify swap in clean_rx_irq if using packet split
      igb: Fix tx/rx_ring_count parameters for igb on suspend/resume/ring resize
      ixgbe: this patch adds support for DCB to the kernel and ixgbe driver
      DCB: Add interface to query for the DCB capabilities of an device.
      DCB: Add interface to query # of TCs supported by device
      DCB: Add interface to query the state of PFC feature.
      DCB: Add support for DCB BCN
      e1000e: disable correctable errors for quad ports while going to D3
      igb: do not use phy ops in ethtool test cleanup for non-copper parts
      igb: remove unneeded bit refrence when enabling jumbo frames
      igb: loopback bits not correctly cleared from RCTL register
      igb: link up/down messages must follow a specific format
      igb: Add support for pci-e Advanced Error Reporting
      igb/e1000e: Naming interrupt vectors
      igb: update handling of RCTL for smaller buffer sizes
      igb: Correctly determine pci-e function number in virtual environment
      igb: defeature tx head writeback
      igb: re-order queues to support cleaner use of ivar on 82576

Alexey Dobriyan (85):
      net: reduce structures when XFRM=n
      net: don't use INIT_RCU_HEAD
      xfrm: C99 for xfrm_dev_notifier
      xfrm: remove unused struct xfrm_policy::next
      net: '&' redux
      netfilter: netns-aware ipt_addrtype
      netfilter: arptable_filter: merge forward hook
      netfilter: netns ebtables: part 1
      netfilter: netns ebtables: part 2
      netfilter: netns ebtables: more cleanup during ebt_unregister_table()
      netfilter: netns ebtables: ebtable_broute in netns
      netfilter: netns ebtables: ebtable_filter in netns
      netfilter: netns ebtables: ebtable_nat in netns
      netfilter: netns ebtables: br_nf_pre_routing_finish() fixup
      net: #ifdef ->sk_security
      net: mark flow_cache_cpu_prepare() as __init
      net: remove struct neigh_table::pde
      net: remove struct dst_entry::entry_size
      net: ifdef struct sock::sk_async_wait_queue
      net: use %pF for /proc/net/ptype
      ematch: simpler tcf_em_unregister()
      netfilter: xt_recent: don't save proc dirs
      netfilter: ip6table_filter: merge LOCAL_IN and FORWARD hooks
      netfilter: nf_conntrack_proto_gre: spread __exit
      net: fix tunnels in netns after ndo_ changes
      ah4/ah6: remove useless NULL assignments
      xfrm: remove useless forward declarations
      xfrm: initialise xfrm_policy_gc_work statically
      netns xfrm: add netns boilerplate
      netns xfrm: add struct xfrm_state::xs_net
      netns xfrm: per-netns xfrm_state_all list
      netns xfrm: per-netns xfrm_state_bydst hash
      netns xfrm: per-netns xfrm_state_bysrc hash
      netns xfrm: per-netns xfrm_state_byspi hash
      netns xfrm: per-netns xfrm_state_hmask
      netns xfrm: per-netns xfrm_state counts
      netns xfrm: per-netns xfrm_hash_work
      netns xfrm: per-netns state GC list
      netns xfrm: per-netns state GC work
      netns xfrm: per-netns km_waitq
      netns xfrm: add struct xfrm_policy::xp_net
      netns xfrm: per-netns policy list
      netns xfrm: per-netns xfrm_policy_byidx hash
      netns xfrm: per-netns xfrm_policy_byidx hashmask
      netns xfrm: per-netns inexact policies
      netns xfrm: per-netns xfrm_policy_bydst hash
      netns xfrm: per-netns policy counts
      netns xfrm: per-netns policy hash resizing work
      netns xfrm: propagate netns into bydst/bysrc/byspi hash functions
      netns xfrm: trivial netns propagations
      netns xfrm: state flush in netns
      netns xfrm: state lookup in netns
      netns xfrm: fixup xfrm_alloc_spi()
      netns xfrm: finding states in netns
      netns xfrm: state walking in netns
      netns xfrm: propagate netns into policy byidx hash
      netns xfrm: policy insertion in netns
      netns xfrm: policy flushing in netns
      netns xfrm: finding policy in netns
      netns xfrm: policy walking in netns
      netns xfrm: lookup in netns
      netns xfrm: xfrm_policy_check in netns
      netns xfrm: xfrm_route_forward() in netns
      netns xfrm: flushing/pruning bundles in netns
      netns xfrm: dst garbage-collecting in netns
      netns xfrm: xfrm_input() fixup
      netns xfrm: per-netns NETLINK_XFRM socket
      netns xfrm: xfrm_user module in netns
      netns xfrm: pass netns with KM notifications
      netns xfrm: KM reporting in netns
      netns xfrm: ->dst_lookup in netns
      netns xfrm: ->get_saddr in netns
      netns xfrm: flush SA/SPDs on netns stop
      netns PF_KEY: part 1
      netns PF_KEY: part 2
      netns PF_KEY: per-netns /proc/pfkey
      netns xfrm: AH/ESP in netns!
      netns xfrm: per-netns MIBs
      netns xfrm: /proc/net/xfrm_stat in netns
      netns xfrm: per-netns sysctls
      netdev: remove pathetic compile-command lines
      hydra: fix compilation
      simeth: convert to net_device_ops
      netns: igmp: allow IPPROTO_IGMP sockets in netns
      netns: igmp: make /proc/net/{igmp,mcfilter} per netns

Alexey Fisher (1):
      ipw2200: make association only if SSID is known.

Andrew Morton (1):
      drivers/net/smc911x.c: smc911x_drv_probe() cleanup

Andrey Borzenkov (3):
      orinoco: reload firmware on resume
      orinoco: cache downloadable firmware image in memory for use during resume
      orinoco: indicate it is using dBm in wireless_stats and spy

Andrey Yurovsky (4):
      ath5k: fix mesh point operation
      mac80211: allow all interfaces types to handle RX action frames
      mac80211: disable BSSID filtering for mesh interfaces
      mac80211_hwsim: enable Mesh Point operation

Andy Fleming (6):
      gianfar: Use gfar_halt to stop DMA in gfar_probe
      gianfar: Convert gianfar to an of_platform_driver
      gianfar: Add macros for stepping through BDs
      phylib: Remove unnecessary "reset" fixups in genphy_setup_forced
      gianfar: Fix packet drop when out of memory
      gianfar: Continue polling until both tx and rx are empty

Andy Gospodarek (1):
      bonding: update docs to correctly reflect arp_ip_target behavior

Andy Whitcroft (1):
      netfilter: ip{,6}t_policy.h should include xp_policy.h

Anna Neal (2):
      libertas: Fine grained configuration of wake-on-lan.
      libertas: Create sysfs entry for changing the mesh probe response limit

Anton Vorontsov (7):
      ucc_geth: Fix endless loop in stop_{tx,rx} routines
      ucc_geth: Fix TX watchdog timeout handling
      ucc_geth: Fix IRQ freeing code in ucc_geth_open()
      ucc_geth: Cleanup repetitive ucc_geth_memclean() calls
      ucc_geth: Fix IO memory (un)mapping code
      ucc_geth: Remove UGETH_FILTERING dead code
      ucc_geth: Eliminate the need for forward references

Arjan van de Ven (1):
      pci: use pci_ioremap_bar() in drivers/net

Arnaldo Carvalho de Melo (1):
      dccp_diag: LISTEN sockets don't have CCIDs

Arnaud Ebalard (1):
      net: Remove unused parameter of xfrm_gen_index()

Atsushi Nemoto (2):
      tc35815: Define more Rx status bits
      tc35815: Enable StripCRC feature

Balazs Scheidler (1):
      TPROXY: implemented IP_RECVORIGDSTADDR socket option

Baruch Siach (1):
      enc28j60: reduce the number of spi transfers in enc28j60_set_bank()

Ben Greear (1):
      ipv4: Fix ARP behavior with many mac-vlans

Ben Hutchings (41):
      sfc: Correct address of gPXE boot configuration in EEPROM
      sfc: Clean up non-volatile memory partitioning
      sfc: Expose flash region storing boot code as MTD
      sfc: Use lm87 and lm90 drivers for board temperature/power monitoring
      sfc: Do not reset when hardware monitor detects a fault
      sfc: Fix dependency for SFC_MTD
      sfc: Board support fixes
      sfc: Change SPI lengths to type size_t
      sfc: Remove unneeded register write
      sfc: Correct interpretation of second param to ethtool phys_id()
      sfc: Clean up waits for flash/EEPROM operations
      sfc: Work around unreliable strap pins
      sfc: Restore phy_flash_cfg module parameter
      sfc: Provide hints to irqbalance daemon
      sfc: Abbreviate self-test names so they are not truncated
      sfc: Don't count RX checksum errors during loopback self-test
      sfc: Remove MII extension cruft
      sfc: Add support for MMDs numbered >15
      sfc: Add phy_type device attribute
      sfc: Clean up board identification
      sfc: Clean up MDIO flag setting
      sfc: Add support for sub-10G speeds
      sfc: Implement auto-negotiation
      sfc: Rework MAC, PHY and board event handling
      sfc: Add support for Solarflare 10Xpress SFT9001
      sfc: Add support for SFN4111T
      sfc: Remove leading spaces
      sfc: Specify a meaningful component for loopback RX-side and PHY tests
      sfc: Use mutex_lock_interruptible() for ethtool EEPROM access
      sfc: Use model numbers for PHY type names
      sfc: Use kzalloc() to ensure struct efx_spi_device is fully initialised
      sfc: Fix synchronisation of efx_mtd_{probe,rename,remove}
      sfc: Version 2.3
      sfc: Generate unique names for per-NIC workqueues
      sfc: Fix unreliable link detection in some loopback modes
      sfc: Clean up PHY mode management in loopback self-test
      sfc: Merge top-level functions for self-tests
      sfc: Add support for multiple PHY self-tests
      sfc: SFT9001: Add cable diagnostics
      sfc: When disabling the NIC, close the device rather than unregistering it
      sfc: If AN is enabled, always read speed/duplex from the AN advertising bits

Benjamin Thery (11):
      net: fix /proc/net/ip_mr_cache display - V2
      net: /proc/net/ip_mr_cache, display Iif as a signed short
      netns: ip6mr: allocate mroute6_socket per-namespace.
      netns: ip6mr: dynamically allocates vif6_table
      netns: ip6mr: store netns in struct mfc6_cache
      netns: ip6mr: dynamically allocate mfc6_cache_array
      netns: ip6mr: declare counter cache_resolve_queue_len per-namespace
      netns: ip6mr: declare mroute_do_assert and mroute_do_pim per-namespace
      netns: ip6mr: declare reg_vif_num per-namespace
      netns: ip6mr: declare ip6mr /proc/net entries per-namespace
      netns: ip6mr: enable namespace support in ipv6 multicast forwarding code

Benoit PAPILLAULT (2):
      ath9k : Display MAC/BB and RF version at startup (v2)
      ath5k: fix 802.11 header padding on RX, unpadding on TX

Bob Copeland (11):
      mac80211: fix a few typos in mac80211 kernel doc
      ath9k: remove useless conditional
      ath5k: fix keytable type buglet in ath5k_hw_reset_key
      ath5k: enable hardware encryption for WEP
      ath5k: update keycache to support TKIP handling
      ath5k: set mac address in add_interface
      ath5k: preserve higher order bits when setting mac address
      ath5k: clean up ath5k_hw_set_key
      ath5k: enable combined michael mic in key cache
      ath5k: fix endianness of bitwise ops when installing mic
      ath5k: correct packet length in tx descriptors

Brian Haley (1):
      bonding: send IPv6 neighbor advertisement on failover

Brice Goglin (7):
      myri10ge: fix per-slice rx/tx_dropped counters
      myri10ge: remove hardcoded sram_size
      myri10ge: update DCA comments
      myri10ge: update firmware headers
      myri10ge: check fragmentation in LRO get_frag_header()
      myri10ge: update firmware headers to 1.4.37
      myri10ge: update driver version to 1.4.4-1.395

Bruce Allan (11):
      e1000e: commit speed/duplex changes for m88 PHY
      e1000e: 82571 check for link fix on 82571 serdes
      e1000e: update comments listing supported parts for each MAC family
      e1000e: check return of pci_save_state
      e1000e: ESB2 config after link up
      e1000e: link up/down messages must follow a specific format
      e1000e: sync change flow control variables with ixgbe
      e1000e: cosmetic newline in debug message
      e1000e: store EEPROM version number to prevent unnecessary NVM reads
      e1000e: fix incorrect link status when switch module pulled
      e1000e: check return code from NVM accesses and fix bank detection

Chaithrika U S (1):
      phy: Add LSI ET1011C PHY driver

Chatre, Reinette (2):
      iwlwifi: replace magic constants with define
      iwlwifi: store ucode version number

Chr (1):
      p54: initialize all deprecated fields

Christian Lamparter (30):
      p54: honour bss_info_changed's short slot time settings
      p54: broken out edcf changes
      p54: refactor statistic timer code
      p54: p54: refactor p54_rx_frame_sent
      p54: fix memory management
      p54: borrow some setup code from stlc45xx
      p54: introduce new names for device firmwares
      p54: more definitions form lmac_longbow.h and pda.h
      p54: put broadcast frames into the right queues
      p54: AP & Ad-hoc testing
      p54: enable Mesh Point support
      p54: minor fixes
      p54pci: cache firmware for suspend/resume
      p54: honour bss_info_changed's basic_rates and other settings
      p54: fix wmm queue settings
      mac80211: add sta_notify_ps callback
      p54: revamp station power save management in access point mode
      p54: utilize cryptographic accelerator
      p54: include support for 2.13.24.0 USB LM87 Firmwares
      p54: refactoring
      p54: per-device names
      p54usb: rewriting rx/tx routines to make use of usb_anchor's facilities
      mac80211: integrate sta_notify_ps cmds into sta_notify
      p54: enforce strict tx_queue limits
      p54: fix oops on faulty devices
      p54: move statistic timer update routine into a workqueue
      p54: update ACK failure statistic counter in real-time
      p54: more accurate rssi to dBm conversion
      p54: remove free_on_tx parameter
      p54usb: bring first generation devices back to life

Colin McCabe (1):
      ath9k: Replace ath9k_opmode with nl80211_iftype

Cyrill Gorcunov (2):
      net: ppp_generic - use idr technique instead of cardmaps
      net: ppp_generic - use DEFINE_IDR for static initialization

Dai Haruki (9):
      gianfar: Optimize interrupt coalescing configuration
      gianfar: Fix eTSEC configuration procedure
      gianfar: Fix VLAN HW feature related frame/buffer size calculation.
      gianfar: Enable padding and Optimize the frame prepended bytes handling
      gianfar: Remove unused gfar_add_fcb() function parameter
      gianfar: Make all BD status writes 32-bit
      gianfar: Add Scatter Gather support
      gianfar: Use interface name in interrupt name to distinguish the source.
      gianfar: Merge Tx and Rx interrupt for scheduling clean up ring

Daniel C. Halperin (1):
      iwlwifi: convert correctly rate_n_flags to PLCP index for mimo3 packets

Daniel Halperin (1):
      iwlwifi: Update reclaim flag

Daniel Lezcano (3):
      veth: Remove useless veth field
      veth: remove unused list
      netns: filter out uevent not belonging to init_net

Daniel Silverstone (1):
      net: Add support for the KS8695 ethernet devices.

Dave Jones (1):
      net: Allow dependancies of FDDI & Tokenring to be modular.

David Brownell (1):
      pegasus: minor resource shrinkage

David Kilroy (8):
      orinoco: Move sources to a subdirectory
      orinoco: Separate fw caching from download
      orinoco: Cache Symbol firmware
      orinoco: Resume spectrum_cs in the same way as orinoco_cs
      orinoco: Provide option to avoid unnecessary fw caching
      orinoco: Fix function names used in debug strings
      orinoco: Fix inappropriate use of IRQ_BAP
      spectrum_cs: Fix function names used in debug strings

David S. Miller (49):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'davem-next' of master.kernel.org:/.../jgarzik/netdev-2.6
      sunrpc: Fix build warning due to typo in %pI4 format changes.
      drivers/net: Kill now superfluous ->last_rx stores.
      net/: Kill now superfluous ->last_rx stores.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'davem-next' of master.kernel.org:/.../jgarzik/netdev-2.6
      Revert "net: Guaranetee the proper ordering of the loopback device."
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      dm9000: Fix build error.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      inet_diag: Missed conversion after changing inet ehash lockl to spinlocks.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'for-david' of git://git.kernel.org/.../chris/linux-2.6
      net: Make sure BHs are disabled in sock_prot_inuse_add()
      axnet_cs: Fix build after net device ops ne2k conversion.
      Revert "hso: Add TIOCM ioctl handling."
      Revert "hso: Fix free of mutexes still in use."
      Revert "hso: Fix crashes on close."
      smc-mca: Fix build failure due to typo.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      phy: Add file missed in previous commit.
      Merge branch 'master' of ssh://master.kernel.org/.../rusty/linux-2.6-for-linus
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      bluetooth: Fix rfcomm_sock_ioctl() build failure with debugging enabled.
      bluetooth: Fix unused var warning properly in rfcomm_sock_ioctl().
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      8390/8390p: Fix compat netdev ops handling.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      bnx2: Don't redefine FLOW_CTRL_{RX,TX}.
      bnx2x: Fix namespace collision with FLOW_CTRL_{TX,RX}
      Revert "net: release skb->dst in sock_queue_rcv_skb()"
      Revert "xfrm: Accept ESP packets regardless of UDP encapsulation mode"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-david' of git://git.kernel.org/.../chris/linux-2.6
      net: Fix warning fallout from recent NAPI interface changes.
      igb: Fix build warning when DCA is disabled.
      Merge branch 'master' of ../net-next-2.6/ into net2629

David Woodhouse (2):
      atm: 32-bit ioctl compatibility
      atm: Driver for Solos PCI ADSL2+ card.

Denis Joseph Barrow (6):
      hso: Add new usb device id's.
      hso: Fix crashes on close.
      hso: Fix URB submission -EINVAL.
      hso: Fix free of mutexes still in use.
      hso: Add TIOCM ioctl handling.
      hso: Hook up ->reset_resume

Divy Le Ray (8):
      cxgb3 - enable lro control through ethtool
      cxgb3: set hard_xmit in the netdev_ops
      cxgb3: avoid potential memory leak.
      cxgb3: integrate FW and protocol engines in the kernel
      cxgb3: Update FW loading path.
      cxgb3: Add multiple Tx queue support.
      cxgb3: untie strict FW matching
      cxgb3: add control to access embedded images

Don Skidmore (4):
      net: fix dcbnl_setnumtcs operation check
      net: fix DCB setstate to return success/failure
      net: add DCNA attribute to the BCN interface for DCB
      ixgbe: fix the display of DCB control stats in ethtool

Donald Skidmore (1):
      ixgbe: add SFP+ driver support

Ed Swierk (1):
      forcedeth: power down phy when interface is down

Emmanuel Grumbach (2):
      iwlwifi: rename generic iwlagn functions that had a HW specific name
      iwlwifi: rename double inclusion protection name in iwl-commands.h

Eric Dumazet (43):
      udp: introduce struct udp_table and multiple spinlocks
      udp: RCU handling for Unicast packets.
      udp: calculate udp_mem based on low memory instead of all memory
      udp: udp_get_next() should use spin_unlock_bh()
      udp: introduce sk_for_each_rcu_safenext()
      udp: Should use spin_lock_bh()/spin_unlock_bh() in udp_lib_unhash()
      udp: add a missing smp_wmb() in udp_lib_get_port()
      net: sk_free_datagram() should use sk_mem_reclaim_partial()
      net: Introduce read_pnet() and write_pnet() helpers
      net: ib_net pointer should depends on CONFIG_NET_NS
      net: Cleanup of neighbour code
      net: speedup dst_release()
      rcu: Introduce hlist_nulls variant of hlist
      udp: Use hlist_nulls in UDP RCU code
      net: Convert TCP & DCCP hash tables to use RCU / hlist_nulls
      rcu: documents rculist_nulls
      net: make sure struct dst_entry refcount is aligned on 64 bytes
      net: Cleanup of af_unix
      net: af_unix can make unix_nr_socks visbile in /proc
      net: af_unix should update its inuse counter
      net: sctp should update its inuse counter
      net: af_packet should update its inuse counter
      net: make /proc/net/protocols namespace aware
      net: inet_diag_handler structs can be const
      net: af_unix should use KERN_INFO instead of KERN_DEBUG
      net: listening_hash get a spinlock per bucket
      net: convert TCP/DCCP ehash rwlocks to spinlocks
      net: use net_eq() in INET_MATCH and INET_TW_MATCH
      net: some optimizations in af_inet
      net: af_netlink should update its inuse counter
      net: Convert TCP/DCCP listening hash tables to use RCU
      eth: Declare an optimized compare_ether_addr_64bits() function
      net: Make sure BHs are disabled in sock_prot_inuse_add()
      net: Make sure BHs are disabled in sock_prot_inuse_add()
      net: avoid a pair of dst_hold()/dst_release() in ip_append_data()
      net: avoid a pair of dst_hold()/dst_release() in ip_push_pending_frames()
      net: Make sure BHs are disabled in sock_prot_inuse_add()
      net: udp_unhash() can test if sk is hashed
      net: Use a percpu_counter for sockets_allocated
      net: Use a percpu_counter for orphan_count
      net: release skb->dst in sock_queue_rcv_skb()
      net: percpu_counter_inc() should not be called in BH-disabled section
      vlan: fix convertion to net_device_ops

Eric Leblond (4):
      netfilter: xt_NFLOG: don't call nf_log_packet in NFLOG module.
      netfilter: nfmark routing in OUTPUT, mangle, NFQUEUE
      netfilter: nfmark IPV6 routing in OUTPUT, mangle, NFQUEUE
      netfilter: xt_NFLOG is dependant of nfnetlink_log

Eric W. Biederman (6):
      netns: Coexist with the sysfs limitations v2
      netns: Delete virtual interfaces during namespace cleanup
      net: Guaranetee the proper ordering of the loopback device.
      net: Don't leak packets when a netns is going down
      net: fib_rules ordering fixes.
      net: Guaranetee the proper ordering of the loopback device. v2

Fabio Rossi (1):
      mac80211: accept empty strings for hidden SSIDs

Fabrice Bellet (1):
      iwl3945: iwl3945_mac_get_tsf() should not return zero

Felix Fietkau (4):
      minstrel: improve performance for non-MRR drivers
      ath5k: ignore the return value of ath5k_hw_noise_floor_calibration
      mac80211: fix BUILD_BUG_ON() caused by misalignment on arm
      ath5k: Clean up eeprom parsing and add missing calibration data

Florian Fainelli (1):
      r6040: bump release number to 0.19

Francois Romieu (1):
      r8169: convert to net_device_ops

Gerrit Renker (33):
      dccp: Basic data structure for feature negotiation
      dccp: Implement lookup table for feature-negotiation information
      dccp: List management for new feature negotiation
      dccp: Per-socket initialisation of feature negotiation
      dccp: Cleanup routines for feature negotiation
      dccp: Limit feature negotiation to connection setup phase
      dccp: Registration routines for changing feature values
      dccp: Query supported CCIDs
      dccp: Resolve dependencies of features on choice of CCID
      dccp: Mechanism to resolve CCID dependencies
      dccp: Deprecate old setsockopt framework
      dccp: Feature negotiation for minimum-checksum-coverage
      dccp: Deprecate Ack Ratio sysctl
      dccp: Tidy up setsockopt calls
      dccp: Fix bracing in dccp_feat_list_lookup.
      dccp: Set per-connection CCIDs via socket options
      dccp: API to query the current TX/RX CCID
      dccp: Increase the scope of variable-length htonl/ntohl functions
      dccp: Support for Mandatory options
      dccp: Header option insertion routine for feature-negotiation
      dccp: Insert feature-negotiation options into skb
      dccp: Integrate feature-negotiation insertion code
      dccp: Preference list reconciliation
      dccp: Process incoming Change feature-negotiation options
      dccp: Processing Confirm options
      dccp: Feature activation handlers
      dccp: Integration of dynamic feature activation - part 1 (socket setup)
      dccp: Integration of dynamic feature activation - part 2 (server side)
      dccp: Integration of dynamic feature activation - part 3 (client side)
      dccp: Clean up old feature-negotiation infrastructure
      dccp: Remove obsolete parts of the old CCID interface
      dccp: Remove manual influence on NDP Count feature
      dccp ccid-2: Phase out the use of boolean Ack Vector sysctl

Giuseppe Cavallaro (3):
      phy: add natsemi PHY driver
      phy: power management support
      phy: add the ST ste10Xp PHYs

Guo-Fu Tseng (1):
      jme: Remove 64 and 40 bit dma_mask

Halperin, Daniel C (2):
      iwlwifi: update iwl-commands.h for 3 stream support
      iwlwifi: implement iwl_debug_report_frame for iwlagn

Hannes Eder (37):
      pkt_sched: fix sparse warning
      mISDN: use NULL pointer instead of plain integer
      mISDN: consistently define 'debug' as '*u_int'
      mISDN: make global symbols static or include header files
      mISDN: un-export symbol 'plx_lock'
      mISDN: fix sparse warning: symbol 'nskb' shadows an earlier one
      mISDN: fix sparse warning: symbol 'id' shadows an earlier one
      mISDN: comment out unused symbols
      mISDN: timerdev: use __user for mISDN_read's buffer argument
      mISDN: hfcmulti: use __iomem address space modifier
      isdn: eicon: fix sparse warning: make global functions static
      drivers/net: fix sparse warning: use ANSI-style function declaration
      drivers/net: fix sparse warnings: make do-while a compound statement
      drivers/net: fix sparse warning: returning void-valued expression
      drivers/net: fix sparse warnings: make symbols static
      drivers/net/arcnet: fix sparse warnings: make symbols static
      drivers/net/atlx: fix sparse warnings: make symbols static
      drivers/net/bonding: fix sparse warnings: move decls to header file
      drivers/net/cxgb3: comment out dead code
      drivers/net/e1000e: fix sparse warnings: make symbols static
      drivers/net/enic: fix sparse warning: make symbol static
      drivers/net/igb: remove dead code (function 'igb_read_pci_cfg')
      drivers/net/irda: fix sparse warnings: make symbols static
      drivers/net/ixgbe: fix sparse warnings: make symbols static
      drivers/net/netxen: fix sparse warnings: use NULL pointer instead of plain integer
      drivers/net/qlge: fix sparse warnings: make symbols static
      drivers/net/skfp: fix sparse warnings: make symbols static
      drivers/net/tokenring: fix sparse warnings: make symbols static
      drivers/net/tulip: fix sparse warnings: make do-while a compound statement
      drivers/net/wan: fix sparse warnings: make do-while a compound statement
      drivers/net/wan: fix sparse warning: make symbol static
      drivers/net/wan/z85230.c: fix sparse warnings: un-EXPORT symbols
      drivers/net/wireless: fix sparse warnings: make symbols static
      drivers/net/wireless/ath9k: fix sparse warnings: make symbols static
      drivers/net/wireless/b43: fix sparse warnings: make symbols static
      drivers/net/wireless/ipw2x00: fix sparse warnings: make symbols static
      drivers/net/wireless/prism54: fix sparse warnings: make symbols static

Hannes Hering (1):
      ehea: Fix some whitespace issues

Harvey Harrison (35):
      printk: add %pM format specifier for MAC addresses
      printk: add %p6 format specifier for IPv6 addresses
      net: replace all current users of NIP6_SEQFMT with %#p6
      misc: replace NIP6_FMT with %p6 format specifier
      netfilter: replace uses of NIP6_FMT with %p6
      net: replace uses of NIP6_FMT with %p6
      net, misc: replace uses of NIP6_FMT with %p6
      infiniband: use %p6 for printing message ids
      infiniband: ipoib replace IPOIB_GID_FMT with %p6
      infiniband: remove IPOIB_GID_RAW_ARG, IPOIB_GID_ARG, IPOIB_GID_FMT
      uwb: use the %pM formatting specifier in eda.c
      net: remove NIP6(), NIP6_FMT, NIP6_SEQFMT and final users
      printk: add %I4, %I6, %i4, %i6 format specifiers
      net: replace %#p6 format specifier with %pi6
      net: replace %p6 with %pI6
      printk: remove %p6 format specifier, fix up comments
      net: easy removals of HIPQUAD using %pI4 format
      net: replace NIPQUAD() in net/ipv4/netfilter/
      net: replace NIPQUAD() in net/ipv4/ net/ipv6/
      net: replace NIPQUAD() in net/netfilter/
      net: replace NIPQUAD() in net/*/
      drivers: replace NIPQUAD()
      fs: replace NIPQUAD()
      misc: replace NIPQUAD()
      printk: ipv4 address digits printed in reverse order
      ipvs: oldlen, newlen should be be16, not be32
      phonet: sparse annotations of protocol, remove forward declaration
      tipc: trivial endian annotation in debug statement
      isdn: use %pI4, remove get_{u8/u16/u32} and put_{u8/u16/u32} inlines
      net: ip_sockglue.c add static, annotate ports' endianness
      isdn: isdn_net.c annotate struct ip_ports and trivial sparse fixes
      aoe: remove private mac address format function
      decnet: remove private wrappers of endian helpers
      decnet: compile fix for removal of byteorder wrapper
      iwlwifi: remove uses of __constant_{endian} helpers

Helmut Schaa (2):
      iwl3945: remove obsolete irq handling
      ipw2200: fix scanning while associated

Henning Rogge (1):
      nl80211: Add signal strength and bandwith to nl80211station info

Henrique de Moraes Holschuh (7):
      rfkill: use killable locks instead of interruptible
      rfkill: export global states to rfkill-input
      rfkill: add master_switch_mode and EPO lock to rfkill and rfkill-input
      rfkill: honour EPO state when resuming a rfkill controller
      rfkill: rate-limit rfkill-input workqueue usage (v3)
      rfkill: preserve state across suspend
      rfkill: always call get_state() hook on resume

Herbert Xu (11):
      net: Add frag_list support to skb_segment
      net: Add frag_list support to GSO
      net: Add Generic Receive Offload infrastructure
      ipv4: Add GRO infrastructure
      net: Add skb_gro_receive
      tcp: Add GRO support
      ethtool: Add GGRO and SGRO ops
      e1000e: Add GRO support
      tcp: Always set urgent pointer if it's beyond snd_nxt
      ipsec: Remove useless ret variable
      gro: Fix potential use after free

Herton Ronaldo Krzesinski (6):
      rtl8187: adapt for deprecated IEEE80211_CONF_SHORT_SLOT_TIME flag
      rtl8187: add short slot handling for 8187B
      rtl8187: fix 8187B throughput regression
      rtl8187: implement conf_tx callback to configure tx queues
      rtl8187: feedback transmitted packets using tx close descriptor for 8187B
      rtl8187: Fix crash on unload when using SLUB debug

Holger Eitzenberger (23):
      bonding: add and use bond_is_lb()
      bonding: use table for mode names
      bonding: fix compile error if debug enabled
      bonding: use pr_debug instead of own macros
      bonding: remove duplicate declarations
      bonding: make tbl argument to bond_parse_parm() const
      bonding: turn all bond_parm_tbls const
      bonding: improve elaborate port_state assignment
      bonding: introduce and use port_params structure
      bonding: use port_params in __record_pdu()
      bonding: use plain memcpy in __record_default()
      bonding: init port_params from template
      bonding: remove various function declarations
      bonding: use port_params in __update_selected()
      bonding: use port_params in __update_default_selected()
      bonding: use port_params in __update_lacpdu_from_port
      802.3ad: make ntt bool
      802.3ad: turn ports is_enabled into a bool
      802.3ad: turn ports is_individual into a bool
      802.3ad: remove typedef around ad_system
      802.3ad: initialize ports LACPDU from const initializer
      802.3ad: generalize out mac address initializer
      802.3ad: use standard ethhdr instead of ad_header

Holger Schurig (1):
      wireless: fix two bad print_ssid conversions

Ilpo JÃ¤rvinen (40):
      b43legacy: reindent misleading statement
      tcp: collapse more than two on retransmission
      tcp: move tcp_simple_retransmit to tcp_input
      tcp: more aggressive skipping
      tcp: Make SACK code to split only at mss boundaries
      tcp: make tcp_sacktag_one able to handle partial skb too
      tcp: Try to restore large SKBs while SACK processing
      tcp: Make shifting not clear the hints
      tcp: add some mibs to track collapsing
      tcp: handle shift/merge of cloned skbs too
      tcp: tcp_limit_reno_sacked can become static
      tcp: skb_shift cannot cache frag ptrs past pskb_expand_head
      niu: use net_device_stats nowadays available in net_device
      bnx2: use net_device_stats nowadays available in net_device
      ne2: silence static never defined warnings
      dccp: use roundup instead of opencoding
      tcp: force mss equality with the next skb too.
      tcp: Fix thinko making the not-shiftable to cover S|R as well
      tcp: make mtu probe failure to not break gso'ed skbs unnecessarily
      tcp: introduce struct tcp_sacktag_state to reduce arg pressure
      tcp: no need to pass prev skb around, reduces arg pressure
      tcp: drop tcp_bound_rto, merge content of it tcp_set_rto
      tcp: share code through function, not through copy-paste. :-)
      tcp: move some parts from tcp_write_xmit
      tcp: use tcp_write_xmit also in tcp_push_one
      tcp: fix tso_should_defer in 64bit
      icsk: join error paths using goto
      xfrm6_tunnel: join error paths using goto
      ipv6/mcast: join error paths using goto
      ip6mr: use goto to common label instead of opencoding
      xfrm: join error paths
      can: merge error paths
      ax25: join the return paths that free skb
      bt/rfcomm/tty: join error paths
      irda: merge exit paths
      nf/dccp: merge errorpaths
      rpc/rdma: goto instead of copypaste
      hp100: use roundup instead of open coding
      ipmr: merge common code
      libertas: use roundup instead of opencoding

Ingo Molnar (24):
      netfilter: fix warning in net/netfilter/nf_conntrack_proto_tcp.c
      netfilter: fix warning in net/netfilter/nf_conntrack_ftp.c
      s2io: fix warning in drivers/net/s2io.c
      niu: fix warnings in drivers/net/niu.c
      niu: fix another warning in drivers/net/niu.c
      qla3xxx: fix warning in drivers/net/qla3xxx.c
      sunrpc: fix warning in net/sunrpc/xprtrdma/svc_rdma_transport.c
      pkt_sched: fix warning in net/sched/sch_hfsc.c
      ipv6: fix warning in net/ipv6/ip6_flowlabel.c
      dsa: fix warning in net/dsa/mv88e6xxx.c
      dsa: fix warning in net/dsa/mv88e6060.c
      fix warning in fs/dlm/netlink.c
      sis900: fix warning in drivers/net/sis900.c
      z85230: fix warning in drivers/net/wan/z85230.c
      mlx4: fix error path in drivers/net/mlx4/en_rx.c
      cassini: fix warning in drivers/net/cassini.c
      dccp: fix warning in net/dccp/options.c
      mlx4: fix warning in drivers/net/mlx4/mcg.c
      ax25: fix warning in net/ax25/sysctl_net_ax25.c
      sunrpc: fix warning in net/sunrpc/xprtrdma/verbs.c
      bluetooth: fix warning in net/bluetooth/rfcomm/sock.c
      atlx: fix warning in drivers/net/atlx/atl2.c
      depca: fix warning in drivers/net/depca.c
      3c523: fix warning in drivers/net/3c523.c

Ivan Kuten (1):
      mac80211: fix unaligned access in ieee80211_wep_encrypt_data

Ivo van Doorn (26):
      rt2x00: Optimize configuration handling
      rt2x00: Remove ieee80211_bss_conf from rt2x00_intf
      rt2x00: Improve interface_modes initialization
      rt2x00: Release rt2x00 2.2.2
      rt2x00: Remove debugfs CSR access wrappers
      rt2x00: Remove RATE_BASIC flag
      rt2x00: Fix LED state handling
      rt2x00: Block set_key() during suspend/shutdown
      rt2x00: Fix BUG_ON() with antenna handling
      rt2x00: Cleanup TX/RX entry handling
      rt2x00: Optimize get_duration / get_duration_res
      rt2x00: Fix race condition when using inderect registers
      rt2x00: Cleanup indirect register access
      rt2x00: Move rt73usb register access wrappers into rt2x00usb
      rt2x00: Fix TX failure path
      rt2x00: Detect USB BULK in/out endpoints
      rt2x00: Don't switch off LED on initialization
      rt2x00: Optimize IV/EIV handling
      rt2x00: Store retry limit values
      rt2x00: Remove duplicate code
      rt2x00: Implement HW encryption (rt2500usb)
      rt2x00: Release rt2x00 2.2.3
      rt2x00: Add RXDONE_CRYPTO_IV/ICV flags
      rt2x00: Fix check for BSS info changes
      rt2x00: Move crypto TX descriptor handling to rt2x00crypto.c
      rt2x00: Correctly initialize AID during set_key()

James Chapman (1):
      l2tp: fix UDP checksum support

Jarek Poplawski (24):
      pkt_sched: sch_generic: Add Qdisc_ops peek() method.
      pkt_sched: sch_generic: Add generic qdisc->ops->peek() implementation.
      pkt_sched: Add qdisc->ops->peek() implementation.
      pkt_sched: Use qdisc->ops->peek() instead of ->dequeue() & ->requeue()
      pkt_sched: Add peek emulation for non-work-conserving qdiscs.
      sch_netem: Remove classful functionality
      sch_netem: Replace ->requeue() method with open code
      pkt_sched: sch_generic: Kfree gso_skb in qdisc_reset()
      pkt_sched: Fix qdisc len in qdisc_peek_dequeued()
      pkt_sched: Remove qdisc->ops->requeue() etc.
      pkt_sched: sch_drr: Fix qlen in drr_drop()
      net: gen_estimator: Fix gen_kill_estimator() lookups
      pkt_sched: sch_api: Remove qdisc_list_lock
      pkt_sched: gen_estimator: Optimize gen_estimator_active()
      pkt_sched: sch_htb: Remove htb_class aprio field
      pkt_sched: sch_htb: Remove htb_sched nwc_hit field
      pkt_sched: sch_htb: Clean htb_class prio and quantum fields
      pkt_sched: sch_htb: Remove L2T()
      pkt_sched: sch_htb: Replace HTB_ACCNT() macro with inlines
      pkt_sched: sch_htb: Optimize htb_find_next_upper()
      pkt_sched: sch_htb: Optimize WARN_ONs in htb_dequeue_tree() etc.
      pkt_sched: Annotate uninitialized var in sfq_enqueue()
      net: Fix oops in dev_ifsioc()
      pkt_sched: Remove smp_wmb() in qdisc_watchdog()

Jay Sternberg (3):
      iwlwifi: define firmware file name once
      iwlwifi: expand error lookup and align output
      iwlwifi: indicate txpower is off in sysfs

Jay Vosburgh (3):
      bonding, net: Move last_rx update into bonding recv logic
      bonding: Fix ALB mode to balance traffic on VLANs
      bonding: alternate agg selection policies for 802.3ad

Jeff Kirsher (6):
      DCB: fix kconfig option
      ixgbe: cleanup link up/down messages
      e1000: cleanup link up/down messages
      ixgb: cleanup link up/down messages
      e100: cleanup link up/down messages
      igb: fixup AER with proper error handling

Jesper Dangaard Brouer (3):
      NIU: Implement discard counters
      NIU: Implement discard counters, info/debug statements.
      NIU: Implement discard counters, optimize

Jesse Brandeburg (3):
      ixgbe: add device support for 82598AT (copper 10GbE) adapters
      pktgen: add full reset functionality
      ixgbe: fix dma mapping unbalance

Jianjun Kong (12):
      af_unix: clean up net/unix/af_unix.c garbage.c sysctl_net_unix.c
      net: clean up net/ipv4/ah4.c esp4.c fib_semantics.c inet_connection_sock.c inetpeer.c ip_output.c
      net: clean up net/ipv4/ipip.c raw.c tcp.c tcp_minisocks.c tcp_yeah.c xfrm4_policy.c
      net: clean up net/ipv4/fib_frontend.c fib_hash.c ip_gre.c
      net: clean up net/ipv4/igmp.c
      net: clean up net/ipv4/ip_sockglue.c tcp_output.c
      net: clean up net/ipv4/ipmr.c
      net: clean up net/ipv4/ip_fragment.c tcp_timer.c ip_input.c
      net: clean up net/ipv4/pararp.c
      net: clean up net/ipv4/devinet.c
      net: clean up net/ipv4/tcp_ipv4.c
      net: remove two duplicated #include

Jiri Slaby (1):
      Ath5k: add AP mode

Jirka Pirko (3):
      tokenring/3c359.c: fix allocation null check
      tokenring/3c359.c: Fix error message when allocating tx_ring
      tokenring/3c359.c: Prevent possible mem leak when open failed

Joe Chou (2):
      r6040: fix wrong logic in mdio code
      r6040: save and restore MIER correctly in the interrupt routine

Joe Korty (1):
      forcdeth: increase max_interrupt_work

Joe Perches (3):
      include/net net/ - csum_partial - remove unnecessary casts
      drivers/s390/ - csum_partial - remove unnecessary casts
      net/ipv6/ip6mr.c: Use kmem_cache_zalloc, remove memset

Johannes Berg (72):
      mac80211: convert to %pM away from print_mac
      net: convert print_mac to %pM
      net: convert more to %pM
      mac80211: remove aggregation status write support from debugfs
      mac80211: remove writable debugs mesh parameters
      mac80211: minor code cleanups
      mac80211: remove wiphy_to_hw
      mac80211: clean up ieee80211_hw_config errors
      mac80211: remove max_antenna_gain config
      mac80211: fix short slot handling
      802.11: clean up/fix HT support
      mac80211: kill hw.conf.antenna_sel_{rx,tx}
      mac80211: introduce hw config change flags
      mac80211: provide sequence numbers
      nl80211: export HT capabilities
      iwl3945: fix station stuff in RC algorithm
      mac80211: make retry limits part of hw config
      mac80211: move bss_conf into vif
      mac80211: rewrite HT handling
      p54/rtl8187: fix up the seqno patch
      mac80211: add might_sleep to hw_config
      mac80211/drivers: rewrite the rate control API
      p54: implement MRR
      make ieee80211 invisible
      nl80211: fix monitor flags
      mac80211: remove rate_control_clear
      mac80211: inform userspace of probe/auth/assoc timeout
      wireless: don't publish __regulatory_hint
      wireless: remove cfg80211_reg_mutex
      wireless: get rid of pointless request list
      wireless: fix EU check
      mac80211: insert AP sta entry after filling it
      wireless: remove write-only 'granted' variable
      wireless: make regdom passing semantics simpler
      wireless: remove struct regdom hinting
      wireless: clean up regulatory ignore_request function
      wireless regulatory: move ignore_request
      mac80211: fix two kernel-doc warnings
      wireless: move mesh config length constant
      wireless: fix a few sparse warnings
      ath9k: remove useless NULL initialisers
      iwl3945: remove dead code
      iwlwifi: remove implicit direct scan
      iwlwifi: remove unused essid variable
      b43/legacy: remove SSID code
      adm8211: remove SSID code
      mac80211: remove SSID driver code
      iwl3945: remove bogus comment
      don't use net/ieee80211.h
      wireless: implement basic rate helper function
      b43: implement short slot and basic rate handling
      libertas_tf: fix skb tail pointer
      b43legacy: implement short slot and basic rate handling
      b43: remove rate index warning
      wireless: clean up sysfs code using %pM
      ath5k: name pci driver "ath5k" too
      mac80211: only transition STAs ps->wake on data frames
      cfg80211: handle SIOCGIWNAME
      cfg80211: handle SIOCGIWMODE/SIOCSIWMODE
      wireless: clean up radiotap a bit
      cfg80211: fix wiphy remove if no regulatory request
      cfg80211: "fix" 11d oops
      p54: fix lm87 checksum endianness
      iwlwifi: disable AP mode
      mac80211: improve sta_notify documentation
      cfg80211: fix nl80211 frequency handling
      mac80211: only create default STA interface if supported
      ath9k: remove fragmentation workaround again
      mac80211: remove fragmentation offload functionality
      mac80211/cfg80211: check endianness in sparse runs
      rfkill: strip pointless notifier chain
      forcedeth: don't poll NV event 36

John Daiker (2):
      ath5k: reduce checkpatch.pl errors
      rt2x00: reduce checkpatch.pl errors

John W. Linville (21):
      p54: integrate parts of lmac_longbow.h and other parts of stlc45xx
      wireless: consolidate on a single escape_essid implementation
      wireless: remove NETWORK_EMPTY_ESSID flag
      wireless: escape_ssid should handle non-printables
      wireless: use individual buffers for printing ssid values
      wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h conflicts
      p54: eliminate warning for uninitialized variable 'tim_len'
      ath9k: correct warning about unintialized variable 'tid'
      netdevice zd1201: Convert directly reference of netdev->priv to netdev_priv()
      ipw2100, ipw2200: select LIB80211
      lib80211: absorb crypto bits from net/ieee80211
      lib80211: consolidate crypt init routines
      ipw2x00: relocate ipw2100/ipw2200 to common directory
      net/ieee80211 -> drivers/net/ipw2x00/libipw_* rename
      mac80211: add explicit padding in struct ieee80211_tx_info
      rtl8180: adapt for deprecated IEEE80211_CONF_SHORT_SLOT_TIME flag
      MAINTAINERS: claim maintenance over rtl818x drivers
      mac80211_hwsim: fix-up some print_mac merge damage
      hostap: select required crypto bits in Kconfig
      mac80211: deauth when interface is marked down
      ieee80211_security: correct warning about width of auth_mode

Jouni Malinen (25):
      mac80211_hwsim: Debug info for BSS config changes
      nl80211: Add basic rate configuration for AP mode
      mac80211_hwsim: Debug info for TX queue parameters
      nl80211: Add TX queue parameter configuration
      mac80211_hwsim: Make sure beacon_timer gets deleted
      mac80211: Allow AP mode to be enabled
      mac80211_hwsim: Add support for client PS mode
      mac80211_hwsim: Update documentation (AP mode enabled)
      nl80211: Report max TX power in NL80211_BAND_ATTR_FREQS
      nl80211: Change max TX power to be in mBm instead of dBm
      nl80211: Add frequency configuration (including HT40)
      ath9k: Free Beacon skbs in AP mode
      ath9k: Disable staggered Beacon frame scheduling
      mac80211: Disable requests for new scans in AP mode
      ath9k: Do not remove header padding on RX from short frames
      mac80211: Add HT rates into RX status reporting
      ath9k: Report HT rates in RX status
      mac80211: Send Layer 2 Update frame on reassociation
      mac80211: Remove radiotap rate-present flag for HT
      ath9k: Fix TX status reporting for retries and MCS index
      ath9k: Remove MAC header pad before reporting TX status
      ath9k: Fix a NULL pointer dereference in ath_rate_get
      ath9k: Key cache allocation for AP mode
      ath9k: Fix key cache slot selection for splitmic
      ath9k: Fixed RX decryption status reporting

Julia Lawall (10):
      drivers/net/wireless/ath9k/rc.c: use ARRAY_SIZE
      Bluetooth: Change simple_strtol to simple_strtoul
      drivers/isdn/mISDN: use ARRAY_SIZE
      drivers/net/hamradio: Move a dereference below a NULL test
      drivers/net/wan: Remove redundant test
      drivers/net/au1000_eth.c: Remove redundant test
      drivers/net/ehea: Remove redundant test
      drivers/net: Remove redundant test
      drivers/net/wan: Remove redundant test
      net/appletalk: Remove redundant test

Julius Volz (3):
      IPVS: Add IPv6 support to SH and DH schedulers
      IPVS: Add IPv6 support to LBLC/LBLCR schedulers
      IPVS: Remove supports_ipv6 scheduler flag

Kalle Valo (4):
      mac80211: document ieee80211_tx_info.pad
      mac80211: enable IEEE80211_CONF_PS only when associated
      mac80211: track master queue status
      mac80211: implement dynamic power save

Karen Xie (1):
      cxgb3: manage private iSCSI IP address

Karsten Keil (1):
      misdn: Fix lockdep warning

Kay Sievers (2):
      net: struct device - replace bus_id with dev_name(), dev_set_name()
      ssb: struct device - replace bus_id with dev_name(), dev_set_name()

Kolekar, Abhijeet (3):
      iwl3945 : Fix Sparse Warnings
      iwl3945 : Simplify iwl3945_send_beacon_cmd
      iwl3945 : Simplify iwl3945_pci_probe

Komuro (1):
      fmvj18x_cs: write interrupt ack bit for lan and modem to work simultaneously.

Krzysztof Halasa (1):
      net: PHYLIB mdio fixes #2

Krzysztof HaÅ‚asa (28):
      WAN: split hd6457x.c into hd64570.c and hd64572.c
      WAN: remove SCA II support from SCA drivers
      WAN: remove SCA support from SCA-II drivers
      WAN: convert HD64572-based drivers to NAPI.
      WAN: TX-done handler now uses the ownership bit in HD64572 drivers.
      WAN: HD64572 already handles TX underruns with DMAC.
      WAN: rework HD64572 interrupts a bit.
      WAN: Simplify HD64572 status handling.
      WAN: don't print HD64572 driver versions anymore.
      WAN: Simplify HD64572 drivers.
      WAN: HD64572 drivers don't use next_desc() anymore.
      WAN: Correct comments in hd6457[02].c
      WAN: Simplify sca_init_port() in HD64572 driver.
      WAN: new synchronous PPP implementation for generic HDLC.
      WAN: syncppp.c is no longer used by any kernel code. Remove it.
      WAN pc300too.c: Fix PC300-X.21 detection
      IXP4xx: check for queue being empty in qmgr_release_queue().
      IXP4xx: clear IRQ stat in qmgr_disable_irq().
      IXP4xx: Silence section mismatch warning in Ethernet driver.
      IXP4xx: Make the Ethernet driver use built-in netdev stats.
      IXP4xx: Add PHYLIB support to Ethernet driver.
      IXP4xx: Add PHYLIB MII ioctl to the Ethernet driver.
      IXP4xx: Add ethtool support to Ethernet driver.
      WAN: Add IXP4xx HSS HDLC driver.
      Update MAINTAINERS entries for IXP4xx and WAN network drivers.
      IXP4xx: move common debugging from network drivers to QMGR module.
      HDLC_PPP: Fix Configure-Ack to return original options as required by the standard.
      Convert ixp4xx_eth driver to use net_device_ops.

Larry Finger (20):
      p54: Move rx_mtu to struct bootrec_desc
      hostap: Fix sparse warnings
      rtl8187: Remove large delays
      rtl8187: Remove OFDM delays
      rtl8187: Remove CCK delays
      rtl8187: Remove msleep calls after calls to rtl8225_write
      rtl8187: Remove primitive write delays
      rtl8187: Reduce channel switch delay
      rtl8187: Change TX power settings
      Move all rtl818x files to a common directory.
      Update of MAINTAINERS for RTL8187
      rtl8187: Update file authorship in comments
      rtl8187: Remove module warning and dependence on CONFIG_EXPERIMENTAL
      mac80211: Fix pid rate-setting algorithm to allow rate changes
      rtl8187: Fix transmission count sent to mac80211
      rtl8187: Improve wireless statistics for RTL8187
      rtl8187: Use usb anchor facilities to manage urbs
      b43legacy: Fix sparse warnings
      rtl8187: Fix error returns
      mac80211: Print unknown packet type in tasklet_handler

Lennert Buytenhek (6):
      mv643xx_eth: checkpatch fixes
      mv643xx_eth: introduce per-port register area pointer
      mv643xx_eth: inline txq_alloc_desc_index()
      mv643xx_eth: implement ->set_rx_mode()
      mv643xx_eth: move receive error handling out of line
      mv643xx_eth: calculate descriptor pointer only once in rxq_refill()

Luis R. Rodriguez (32):
      ath5k/ath9k: correct signal quality
      ath9k: correct signal quality report
      ath5k: correct ath5k signal quality
      mac80211: make use of regulatory tx power settings on change of tx power
      ath9k: remove pointless sc_txintrperiod and spin_lock_bh on tx prepare
      ath9k: enable RX interrupt mitigation
      ath9k: Allow user to change tx power when asked
      ath9k: use ETH_P_PAE
      cfg80211: a reg rule is invalid if freq diff is 0
      cfg80211: Add regulatory domain intersection capability
      cfg80211: make use of reg macros on REG_RULE
      cfg80211: Add kdoc for struct regulatory_request
      ath5k: allow APs to receive beacons
      ath9k: enable RXing of beacons on STA/IBSS
      cfg80211: mark negative frequencies as invalid
      cfg80211: remove switch from __regulatory_hint()
      cfg80211: remove switch from __set_regdom()
      cfg80211: separate intersection section in __set_regdom()
      cfg80211: expect different rd in cfg80211 when intersecting
      cfg80211: call_crda() won't tell us if CRDA was present
      cfg80211: mark regdomains with > NL80211_MAX_SUPP_REG_RULES invalid
      cfg80211/mac80211: Add 802.11d support
      cfg80211: add support for custom firmware regulatory solutions
      iwlwifi: enable custom fw regulatory solution
      ath9k: Clarify we only want 32-bit DMA
      ath9k: make DMA memory consistent
      mac80211: don't assume driver has been attached on registration
      mac80211: make Minstrel the default rate control algorithm
      ath9k: Handle -ENOMEM on RX gracefully
      nl80211: relicense nl80211.h under the ISC
      ath9k: Check for pci_map_single() errors
      ath9k: Use GFP_ATOMIC when allocating TX private area

Luotao Fu (1):
      smc91x: remove isa stuff from smc91x driver

Marcel Holtmann (10):
      Bluetooth: Add fine grained mem_flags usage to btusb driver
      Bluetooth: Handle bulk URBs in btusb driver from notify callback
      Bluetooth: Add suspend/resume support to btusb driver
      Bluetooth: Fix warnings for bt_key_strings and bt_slock_key_strings
      Bluetooth: Remove deprecated hci_usb driver
      Bluetooth: Send HCI Reset command by default on device initialization
      Bluetooth: Allow SCO audio with Asus WL-BTD202 dongle
      Bluetooth: Enable per-module dynamic debug messages
      Bluetooth: Fix format arguments warning
      Bluetooth: Fix RFCOMM release oops when device is still in use

Mark McLoughlin (4):
      virtio_net: Recycle some more rx buffer pages
      virtio_net: hook up the set-tso ethtool op
      virtio_net: VIRTIO_NET_F_MSG_RXBUF (imprive rcv buffer allocation)
      virtio_net: large tx MTU support

Martin Willi (3):
      xfrm: Notify changes in UDP encapsulation via netlink
      xfrm: Accept XFRM_STATE_AF_UNSPEC SAs on IPv4/IPv6 only hosts
      xfrm: Accept ESP packets regardless of UDP encapsulation mode

Matt Carlson (30):
      tg3: Add 5761S support
      tg3: Use pci_ioremap_bar()
      tg3: Preserve DASH connectivity when WOL enabled
      tg3: Preserve LAA when device control is released
      tg3: Reclaim TG3_FLG3_5761_5784_AX_FIXES flag
      tg3: Do not enable APE on bcm5700
      tg3: Move phylib report to end of tg3_init_one
      tg3: Refine power management and WOL code
      tg3: Allow WOL for phylib controlled Broadcom phys
      tg3: Refine phylib support
      tg3: 5785 enhancements
      broadcom: Add flow control support
      broadcom: Refine expansion register access routine
      broadcom: Add support for BCM50610
      tg3: Update version to 3.95
      tg3: Use NET_IP_ALIGN
      tg3: Qualify use of tp->pcix_cap
      tg3: Prevent corruption at 10 / 100Mbps w CLKREQ
      tg3: Enable GPHY APD on select devices
      tg3: Extract FW ver from alt NVRAM formats
      tg3: Embrace pci_ioremap_bar()
      tg3: Allow GPHY powerdown on 5761
      tg3: Add 57780 support
      broadcom: Add 57780 support
      tg3: Update version to 3.96
      tg3: WOL fixes
      tg3: Cleanup IPV6 LSO
      tg3: Remove unused cfgspc device members
      tg3: tg3.h cleanups
      tg3: Update version to 3.97

Matt Mackall (1):
      tcp: Stop scaring users with "treason uncloaked!"

Michael Buesch (3):
      b43: Fix some MAC locking
      b43: Suspend MAC while killing the radio
      b43: Add key memory dumping

Michael Chan (7):
      bnx2: Add PCI ID for 5716S.
      bnx2: Restrict WoL support.
      bnx2: Set rx buffer water marks based on MTU.
      bnx2: Reorganize timeout constants.
      bnx2: Update version to 1.8.2.
      bnx2: Rename MSI-X vectors.
      bnx2: Update version to 1.9.0.

Mike Frysinger (2):
      smc91x: add __init markings to smc_drv_probe()
      netdev/smc91x: unify Blackfin code a bit and use proper read/write functions

Mohamed Abbas (6):
      iwlwifi: clear scanning bits upon failure
      iwlwifi: do not call statistics from rfkill
      iwlagn: fix resume for ADHOC network
      iwl3945: fix resume for ADHOC network
      iwlwifi: fix resume while txpower off
      iwlagn: fix agn rate scaling

Nathan Lynch (1):
      ehea: use get_zeroed_page for alignment-sensitive allocation

Neil Horman (2):
      net: implement emergency route cache rebulds when gc_elasticity is exceeded
      net: Remove unused netdev arg from some NAPI interfaces.

Neil Turton (1):
      sfc: Add option to use a separate channel for TX completions

Nick Andrew (2):
      wireless: Fix incorrect use of loose in wext.c
      net: Fix incorrect use of loose in spider_net.c

Nick Kossifidis (3):
      ath5k: Update interrupt masking code
      ath5k: Update PCU code
      ath5k: Fix IMR init

Nick Pelly (1):
      Bluetooth: Respect HCI_UART_DEBUG config in hci_ll.c

Nicolas Dichtel (1):
      xfrm6: handling fragment

Oliver Hartkopp (2):
      vcan: convert to net_device_ops
      vcan: whitespace fixes

Oliver Neukum (2):
      net: prepare usb net drivers for addition of status as a parameter
      net: startup race in hso driver

PJ Waskiewicz (1):
      ixgbe: Fix usage of netif_*_all_queues() with netif_carrier_{off|on}()

Pablo Neira Ayuso (7):
      netfilter: ctnetlink: use nf_conntrack_get instead of atomic_inc
      netfilter: ctnetlink: use EOPNOTSUPP instead of EINVAL if the conntrack	has no helper
      netfilter: ctnetlink: get rid of module refcounting in ctnetlink
      netfilter: nf_conntrack: connection tracking helper name persistent aliases
      netfilter: ctnetlink: helper modules load-on-demand support
      netfilter: ctnetlink: deliver events for conntracks changed from userspace
      filter: add SKF_AD_NLATTR_NEST to look for nested attributes

Patrick McHardy (12):
      netlink: constify struct nlattr * arg to parsing functions
      pkt_sched: Add ->peek() methods for fifo, prio and SFQ qdiscs.
      netfilter: nfnetlink_log: fix warning and prototype mismatch
      netfilter: nf_conntrack: fix warning and prototype mismatch
      netlink: avoid memset of 0 bytes sparse warning
      pkt_sched: add DRR scheduler
      pkt_sched: remove unnecessary xchg() in packet schedulers
      pkt_sched: remove unnecessary xchg() in packet classifiers
      netfilter: nf_conntrack_proto_sctp: avoid bogus warning
      netfilter: nf_conntrack_ftp: change "partial ..." message to pr_debug()
      pkt_sched: sch_drr: fix drr_dequeue loop()
      netlink: allow empty nested attributes

Paulius Zaleckas (2):
      phylib: rename mdio-ofgpio to mdio-gpio
      phylib: make mdio-gpio work without OF (v4)

Pavel Roskin (3):
      p54: don't report known but unhandled EEPROM codes as unknown
      orinoco: fix last beacon reporting on 64-bit systems
      airport: remove useless return in a function returning void

Peter P Waskiewicz Jr (4):
      ixgbe: Implement PCIe AER support
      net: Init NAPI dev_list on napi_del
      ixgbe: Fix NAPI enable/disable path when using DCB
      ixgbe: Fix set_ringparam in ixgbe to use the same memory pools.

Petr Tesarik (1):
      tcp: remove an unnecessary field in struct tcp_skb_cb

Qinghuang Feng (1):
      net: remove redundant argument comments

Rafael J. Wysocki (2):
      skge: adapt skge to use reworked PCI PM
      e100: adapt to the reworked PCI PM

Rami Rosen (13):
      mac80211: remove unused declaration of struct sta_attribute.
      mac80211: use HWSIM_STA_MAGIC in hwsim_check_sta_magic() and hwsim_set_sta_magic().
      mac80211: check return value of dev_alloc_skb() in ieee80211_sta_join_ibss().
      mac80211: remove unnecessary include.
      wireless: missing include in lib80211.h
      mac80211: tx module cleanup.
      iwlwifi: cleanup (remove pm_state)
      iwlwifi: fix build error (iwl-rx.c).
      mac80211: misc cleanups
      iwlwifi: fix build warning (iwl-rx.c)
      iwlwifi: remove a parameter (dest) from *_fill_beacon_frame() methods.
      mac80211: fix a typo in ieee80211_send_assoc() method.
      iwlwifi: iwl-tx.c cleanup (remove unused parameter and unused local variable).

Randy Dunlap (2):
      mac80211: remove more excess kernel-doc
      sctp: fix missing label when PROC_FS=n

Reinette Chatre (2):
      iwlwifi: rely on API version read from firmware
      mac80211: remove WARN_ON() from ieee80211_hw_config

Robert Olsson (2):
      niu: Naming interrupt vectors.
      ixgbe: Naming interrupt vectors

Roel Kluin (2):
      net: Make static
      qlge: ql_adapter_down() typo

Roland Dreier (1):
      cxgb3: Fix sparse warning and micro-optimize is_pure_response()

RÃ©mi Denis-Courmont (8):
      Phonet: use net_device built-in stats for GPRS
      Phonet: basic net namespace support
      Phonet: improve GPRS variable names
      Phonet: allocate a non-Ethernet ARP type
      Phonet: allocate separate ARP type for GPRS over a Phonet pipe
      Phonet: use atomic for packet TX window
      Phonet: get rid of deferred work on the transmission path
      Phonet: USB CDC Phonet function for gadget framework

Sakari Ailus (1):
      tlan: Remove broken support for big buffers

Samuel Ortiz (1):
      iwl3945: Select correct sta ID from find_station()

Sangtae Ha (1):
      [TCP] CUBIC v2.3

Scott Feldman (5):
      enic: enable ethtool LRO support
      enic: driver/firmware API updates
      enic: mask off some reserved bits in CQ descriptor for future use
      enic: move wmb closer to where needed: before writing posted_index to hw
      enic: misc cleanup items:

Senthil Balasubramanian (12):
      ath9k: INI update for atheros chipets.
      ath9k: incorrect noise floor threshold values.
      ath9k: Build RFKILL feature even when RFKILL subsystem is a MODULE
      ath9k: IRQ should be disabled before calling free_irq()
      ath9k: Race condition in accessing TX and RX buffers.
      wireless: Incorrect LEAP authentication algorithm identifier.
      ath9k: Adding AR9285 chipset register information.
      ath9k: Adding initvalues for Atheros AR9285 chipset.
      ath9k: Adding support for Atheros AR9285 chipset.
      ath9k: Incorrect band enum causes invalid antenna configuration.
      ath9k: avoid rx frames with corrupted descriptor.
      ath9k: BH shouldn't be enabled when hardirqs are disabled.

Simon Arlott (1):
      netfilter: nf_nat: remove warn_if_extra_mangle

Stephen Hemminger (92):
      vlan: propogate ethtool speed values
      macvlan: add support for ethtool get settings
      atlx: use embedded net_device_stats
      atlx: timer cleanup
      net: increase receive packet quantum
      netem: eliminate unneeded return values
      netdev: network device operations infrastructure
      netdev: introduce dev_get_stats()
      netdev: expose ethernet address primitives
      netdev: convert loopback to net_device_ops
      ifb: convert to net_device_ops
      bridge: convert to net_device_ops
      veth: convert to net_device_ops
      macvlan: convert to net_device_ops
      ip: convert to net_device_ops for ioctl
      vlan: convert to net_device_ops
      bonding: convert to net_device_ops
      e1000e: convert to net_device_ops
      sky2: convert to net_device_ops
      skge: convert to net_device_ops
      8139: convert to net_device_ops
      tun: convert to net_device_ops
      atl1e: convert to net_device_ops
      atlx: convert to net_device_ops
      cxgb3: convert to net_device_ops
      cxgb2: convert to net_device_ops
      e1000: convert to net_device_ops
      via-velocity: convert to net_device_ops
      igb: convert to net_device_ops
      e100: convert to net_device_ops
      ppp: convert to net_device_ops
      enic: convert to net_device_ops
      ixgb: convert to net_device_ops
      tg3: convert to net_device_ops
      forcedeth: convert to net_device_ops
      niu: convert to net_device_ops
      acenic: convert to net_device_ops
      netdev: add more functions to netdevice ops
      dummy: convert to net_device_ops
      ipmr: convert ipmr virtual interface to net_device_ops
      fddi: convert to new network device ops
      defxx: convert driver to net_device_ops
      hippi: convert driver to net_device_ops
      ipip: convert to net_device_ops
      ipv6: convert tunnels to net_device_ops
      ipgre: convert to netdevice_ops
      jme: convert driver to net_device_ops
      s2io: convert to net_device_ops
      qlge: convert to net_device_ops
      qlge: fix sparse warnings
      via-rhine: convert to net_device_ops
      myri10ge: convert to net_device_ops
      mlx4: convert to net_device_ops
      bnx2: convert to net_device_ops
      dl2k: convert to net_device_ops
      netxen: convert to net_device_ops
      sfc: convert to net_device_ops
      tehuti: convert to net_device_ops
      sis900: convert to net_device_ops
      r6040: convert to net_device_ops
      yellowfin: convert to net_device_ops
      ns83820: convert to net_device_ops
      bnx2x: convert to net_device_ops
      hamachi: convert to net_device_ops
      qla3xxx: convert to net_device_ops
      sc92031: convert to net_device_ops
      eql: convert to net_device_ops
      ne2k: convert to net_device_ops
      8139too: use err.h macros
      netdev: add HAVE_NET_DEVICE_OPS
      8390: add common net_device ops
      wd: use net_device_ops
      hp-plus: convert to net_device_ops
      smc: convert to net_device_ops
      ne3210: convert to net_device_ops
      es3210: convert to net_device_ops
      e2100: convert to net_device_ops
      lne390: convert to net_device_ops
      hp: convert to net_device_ops
      ne2: convert to net_device_ops
      apne: convert to net_device_ops
      stnic: convert to net_device_ops
      3c503: convert to net_device_ops
      ne2000: convert to net_device_ops
      tc: propogate errors from tcf_hash_create
      tc: check for errors in gen_rate_estimator creation
      tc: policing requires a rate estimator
      etherh: build fix for net-next
      mac8390: update to net_device_ops
      zorro8390: convert to net_device_ops
      hydra: convert to net_device_ops
      ne-h8300: convert to net_device_ops

Steve Glendinning (15):
      SMSC LAN911x and LAN921x vendor driver
      smsc95xx: add tx checksum offload support
      smsc911x: add dynamic bus configuration
      smsc9420: SMSC LAN9420 10/100 PCI ethernet adapter
      smsc911x: make smsc911x_poll_controller static
      smsc9420: add netpoll support
      smsc9420: add ethtool eeprom support
      smsc9420: add ethtool register dump support
      net: Move flow control definitions to mii.h
      net: Refactor full duplex flow control resolution
      smsc911x: fix BUG if module is removed while interface is up
      smsc911x: convert driver to use net_device_ops
      smsc911x: make smsc911x_ethtool_ops constant
      smsc911x: don't clobber driver_data
      smsc911x: fix platform resource call during module unload

Steve Hodgson (2):
      sfc: Make reset_workqueue driver-global rather than per-NIC
      sfc: Treat probe as unsuccessful if it scheduled a reset

Sujith (57):
      mac80211: Change WARN_ON to WARN_ON_ONCE
      ath9k: Check if the STA supports HT when initializing rate control
      mac80211: Re-enable aggregation
      ath9k: Node cleanup
      ath9k: Simplify node attach/detach routines
      ath9k: Revamp transmit control block
      ath9k: Remove SM Power Save as it is not supported now
      ath9k: Ensure ath_node is not NULL when updating tx chainmask
      ath9k: Use bitfields to store tid's state in a single variable
      ath9k: Revamp VAP management
      ath9k: Refactor hw.c
      ath9k: Remove unused function ath_get_currentCountry()
      ath9k: Streamline attach/detach
      ath9k: Remove unnecessary TSF reset
      ath9k: Enable interrupts at the proper place
      ath9k: Remove ath_tx_aggr_resp()
      ath9k: Clear HT info on starting the driver
      ath9k: Remove internal RX A-MPDU processing
      mac80211: Add a new event in ieee80211_ampdu_mlme_action
      ath9k: Fix compilation failure when RFKILL is enabled
      mac80211: Use the HT capabilities from the IE instead of the station's caps.
      ath9k: Merge struct ath_tx_ratectrl with ath_rate_node
      ath9k: Simplify RC alloc/free functions
      ath9k: Remove ath_setup_rates
      ath9k: Remove ath_rate_newassoc()
      ath9k: Remove half/quarter rate tables
      ath9k: Nuke fixed rate handling in driver
      ath9k: Revamp RX handling
      ath9k: We don't support non-HT devices, so remove superfluous code.
      ath9k: Remove rate control reference in VAP
      ath9k: Remove ath_rate_softc
      ath9k: Use rate_driver_data
      ath9k: Remove ath9k_rate_table
      ath9k: General code scrub
      ath9k: Use helpers
      ath9k: Move TX completion routine to xmit.c
      ath9k: Fix bug in deciphering channel flags
      ath9k: Update TX trigger level on a FIFO underrun.
      ath9k: Use straightforward PCI routines to setup the TX buffer.
      ath9k: Code scrub
      ath9k: Use proper TX channel width for setting channels
      ath9k: Handle channel initialization for AP mode
      ath9k: Use cleaner debug masks
      ath9k: Add ATH9K_DEBUG configuration option
      ath9k: Remove includes that are not needed
      ath9k: Add initial layout for an ath9k specific debugfs mechanism
      ath9k: Add a debugfs file for dumping DMA status
      ath9k: Choose correct ANI calibration period
      ath9k: Fix bug in rate table management
      ath9k: Maintain rate table choice after association
      ath9k: Add a debugfs file to show interrupt statistics
      ath9k: Remove remaining occurrences of CONFIG_SLOW_ANT_DIV
      ath9k: Merge structures ath_atx, ath_node_aggr with ath_node
      ath9k: Refactor struct ath_softc
      mac80211: Fix HT channel selection
      ath9k: Do not use association state to update rate table
      ath9k: Protect config() callback with a mutex

Thomas Graf (1):
      pkt_sched: Control group classifier

Tilman Schmidt (4):
      gigaset: remove unnecessary poll method
      gigaset: get rid of info() and warn() macros
      gigaset: use pr_err() and pr_info()
      gigaset: ifdef cleanup

Tim Gardner (1):
      ipw2x00: change default policy for auto-associate

Tomas Winkler (34):
      iwlwifi: make initial calibration set configurable
      iwlwifi: take a valid antenna upon rate scale init
      iwlwifi: refactor rxon time command
      iwlwifi: remove host commands structures from iwl_cmd
      iwlwifi: add iwl_cmd_queue_free for readability
      iwlwifi: unify tx antenna toggling
      iwlwifi: fix TX cmd dma unmapping
      iwlwifi: tx command must run on same tfd as packet
      iwlwifi: protect headers from double inclusion
      iwlwifi: refactor TX response flow
      iwlwifi: don't update TFD free counter for invalid station
      iwlwifi: parametrize eeprom versions
      iwlwifi: calibration command namespace renaming
      iwlwifi: refactor tx byte count table usage
      iwlwifi: run through spell checker
      mac80211: fix basic rates setting from association response
      iwlwifi: revamp tx scheduler byte count tables handling
      iwlwifi: move spectrum measurement code to iwl-spectrum.c file
      mac80211: rc80211_pid eliminate sparse warnings
      iwlwifi: consolidate station management code
      iwlwifi: rs: remove fc variable and other cleanups
      iwlwifi: iwl-fh.h cleanup
      iwlwifi: enable base band calibration in 5000 HW
      Bluetooth: Fix TX error path in btsdio driver
      mac80211: disassociate prior to unlinking AP/station
      iwlwifi: properly initialize calibration command header
      iwlwifi: 5150 add support for 5150
      iwlwifi: 5150 enable DC calibration
      iwlwifi: 5150 compute ct kill threshold
      iwlwifi: 5150 parametrize eeprom versions
      iwlwifi: remove unused clip_groups priv member
      iwlwifi: remove includes of iwl-helpers.h where not needed
      iwlwifi: remove 4965 from common uCode API structures
      iwlwifi: add contact email to MODULE_AUTHOR

Vasanthakumar Thiagarajan (5):
      ath9k: Configure AR_PHY_SWITCH_COM with apropriate antenna control
      ath9k: Fix panic while unregistering rfkill
      ath9k: Dont update rate control for every AMPDU
      ath9k: Synchronize DMA transfer with CPU at right place
      ath9k: Move rate control alg register/unregister to appropriate place

Vegard Nossum (2):
      Bluetooth: Fix leak of uninitialized data to userspace
      netlink: fix (theoretical) overrun in message iteration

Vivek Natarajan (1):
      mac80211: Look out for some other AP when disassoc is received.

Wang Chen (37):
      airo: Kill directly reference of netdev->priv
      netdevice libertas: Fix directly reference of netdev->priv
      netdevice: safe convert to netdev_priv() #part-1
      netdevice: safe convert to netdev_priv() #part-2
      netdevice: safe convert to netdev_priv() #part-3
      netdevice: safe convert to netdev_priv() #part-4
      netdevice chelsio: Convert directly reference of netdev->priv
      netdevice: 82596: Convert netdev->priv to netdev_priv
      netdevice hamradio: Convert directly reference of netdev->priv
      netdevice lance: Convert directly reference of netdev->priv
      netdevice ppp: Convert directly reference of netdev->priv
      netdevice ni65: Convert directly reference of netdev->priv
      netdevice wanrouter: Convert directly reference of netdev->priv
      ixgbe: convert directly reference of netdev->priv
      netdevice hdlc: Convert directly reference of netdev->priv
      netdevice pc300: Convert directly reference of netdev->priv
      netdevice pc300: Add the reason about PC300 BROKEN in Kconfig
      netdevice sbni: Convert directly reference of netdev->priv
      infiniband: Kill directly reference of netdev->priv
      hysdn: Kill directly reference of netdev->priv
      isdn: Kill directly reference of netdev->priv
      dvb: Kill directly reference of netdev->priv
      mptlan: Kill directly reference of netdev->priv
      bond: Kill directly reference of netdev->priv
      ixgbe: function comment typo
      e1000: e1000_adapter->polling_netdev is useless
      if_usb: Kill directly reference of netdev->priv
      simeth: Kill directly reference of netdev->priv
      xtensa: Kill directly reference of netdev->priv
      um: Kill directly reference of netdev->priv
      sgi-xp: Kill directly reference of netdev->priv
      s390_net: Kill directly reference of netdev->priv
      staging-p80211: Kill directly reference of netdev->priv
      staging-slicoss: Kill directly reference of netdev->priv
      staging-winbond: Kill directly reference of netdev->priv
      netdevice: Kill netdev->priv
      netdevice zd1201: Use after free

Wei Yongjun (6):
      xfrm: Cleanup for unlink SPD entry
      sctp: Bring SCTP_MAXSEG socket option into ietf API extension compliance
      sctp: Fix a typo in socket.c
      sctp: Implement socket option SCTP_GET_ASSOC_NUMBER
      sctp: Avoid memory overflow while FWD-TSN chunk is received with bad stream ID
      sctp: Add validity check for SCTP_PARTIAL_DELIVERY_POINT socket option

Winkler, Tomas (21):
      iwlwifi: reorganize flow handler bitology
      iwlwifi: trivial removal of some 4965 remaining from iwl-agn-rs.h
      iwlwifi: iwl-agn-rs: initialize rs with valid antenna
      iwlwifi: trivial fix in includes
      iwlwifi: don't fail power set when calibration is not done yet
      iwlwifi: move rx queue read pointer into rxq
      iwlwifi: move iwl_print_hex_dump to iwl-debug.h
      iwlwifi: get some more information about command failure
      iwlwifi: move iwl_clear_stations_table to iwl-sta.c
      iwlwifi: 4965 define firmware file name once
      iwlwifi: TX setup fix confusion between TX queue and TX DMA channel
      iwlwifi: TX update chicken bits
      iwlwifi: 5150 enable LO, TXIQ and BB calibrations
      iwlwifi: move host command check function into separate file
      iwlwifi: move disable/enable interrupts to iwl-core.c
      iwlwifi: move channels sysfs to debugfs
      iwlwifi: change email contact information
      iwlifi: remove twice defined SINGLE_FRAME RX FH MASK
      iwlwifi: 3945 remove qos module parameter
      iwlwifi: remove qos module parameter
      iwlwifi: cleanup iwl-dev.h

Wu Fengguang (2):
      generic swap(): ath9k: rename swap() to swap_array()
      iwlwifi: remove useless goto

Wu, Fengguang (4):
      iwlwifi: add line feed to printk
      iwlwifi: update comments on the debug interface
      iwlwifi: use type uint for module param debug
      iwlwifi: use meaningful vars in _iwl_poll_bit()

Yang Hongyang (3):
      ipv6: Add IPV6_PKTINFO sticky option support to setsockopt()
      ipv6: fix the return interface index when get it while no message is received
      ipv6: fix the outgoing interface selection order in udpv6_sendmsg()

Yevgeny Petrilin (5):
      mlx4_en: Memory leak on completion queue free
      mlx4_en: Removed TX locking when polling TX cq
      mlx4_en: Removed redundant cq->armed flag
      mlx4_en: Removed Interrupt moderation module parameters
      mlx4_en: Remove pauses module parameters.

Zhaolei (2):
      Fix debugfs_create_bool's error checking method for wireless/iwlwifi/
      Fix debugfs_create_*'s error checking method for wireless/rt2x00/

Zhu Yi (4):
      mac80211: print reason code for deauth/dissoc frames
      iwlwifi: fix printk size format error
      iwlwifi: fix DMA channel number in iwl_txq_ctx_stop
      iwlwifi: use GFP_KERNEL to allocate Rx SKB memory

Zhu, Yi (9):
      iwlwifi: fix priv->iw_mode setting when multiple vif are configured
      iwlwifi: use Rx single frame mode (one Rx frame per RB)
      iwlwifi: configure_filter rewrite
      iwlwifi: some fh document fix and cleanup
      iwlwifi: fix time interval misuse in iwl_poll_{direct_}bit
      iwlwifi: fix "MAC in deep sleep" error
      iwlwifi: iwl_poll_{direct_}bit cleanup
      iwlwifi: use rmb/wmb to protect indirect mmio operation
      iwlwifi: use iwl_poll_direct_bit in EEPROM reading

akeemting (1):
      jme: GHC register control fix for new hardware

colin@cozybit.com (1):
      Add nl80211 commands to get and set o11s mesh networking parameters

herton (1):
      rtl8187: fix retry count passed in rtl8187_tx

 Documentation/DocBook/Makefile                     |    2 +-
 Documentation/DocBook/networking.tmpl              |    3 -
 Documentation/DocBook/wanbook.tmpl                 |   99 -
 Documentation/RCU/rculist_nulls.txt                |  167 +
 Documentation/feature-removal-schedule.txt         |    7 -
 Documentation/networking/README.ipw2200            |    2 +-
 Documentation/networking/bonding.txt               |   68 +-
 Documentation/networking/dccp.txt                  |   32 +-
 Documentation/networking/driver.txt                |    2 +-
 Documentation/networking/generic-hdlc.txt          |    8 +-
 Documentation/networking/ip-sysctl.txt             |    6 +
 Documentation/networking/mac80211_hwsim/README     |    9 +-
 Documentation/networking/netdevices.txt            |    2 +-
 Documentation/networking/regulatory.txt            |   22 +-
 Documentation/powerpc/dts-bindings/fsl/tsec.txt    |   12 +-
 Documentation/rfkill.txt                           |   20 +-
 MAINTAINERS                                        |   48 +-
 arch/arm/mach-ixp4xx/fsg-setup.c                   |    9 +-
 arch/arm/mach-ixp4xx/include/mach/qmgr.h           |   35 +-
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c                 |   44 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c               |    5 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c                 |    5 +-
 arch/ia64/hp/sim/simeth.c                          |   25 +-
 arch/powerpc/boot/dts/asp834x-redboot.dts          |   20 +
 arch/powerpc/boot/dts/ksi8560.dts                  |   20 +
 arch/powerpc/boot/dts/mpc8313erdb.dts              |   20 +
 arch/powerpc/boot/dts/mpc8315erdb.dts              |   19 +
 arch/powerpc/boot/dts/mpc8349emitx.dts             |   18 +
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |    5 +
 arch/powerpc/boot/dts/mpc834x_mds.dts              |   19 +
 arch/powerpc/boot/dts/mpc8377_mds.dts              |   19 +
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |   19 +
 arch/powerpc/boot/dts/mpc8378_mds.dts              |   19 +
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |   17 +
 arch/powerpc/boot/dts/mpc8379_mds.dts              |   18 +
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |   18 +
 arch/powerpc/boot/dts/mpc8536ds.dts                |   18 +
 arch/powerpc/boot/dts/mpc8540ads.dts               |   31 +
 arch/powerpc/boot/dts/mpc8541cds.dts               |   18 +
 arch/powerpc/boot/dts/mpc8544ds.dts                |   20 +
 arch/powerpc/boot/dts/mpc8548cds.dts               |   44 +
 arch/powerpc/boot/dts/mpc8555cds.dts               |   18 +
 arch/powerpc/boot/dts/mpc8560ads.dts               |   18 +
 arch/powerpc/boot/dts/mpc8568mds.dts               |   18 +
 arch/powerpc/boot/dts/mpc8572ds.dts                |   45 +
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |   45 +
 arch/powerpc/boot/dts/sbc8349.dts                  |   18 +
 arch/powerpc/boot/dts/sbc8548.dts                  |   18 +
 arch/powerpc/boot/dts/sbc8560.dts                  |   18 +
 arch/powerpc/boot/dts/sbc8641d.dts                 |   44 +
 arch/powerpc/boot/dts/stx_gp3_8560.dts             |   18 +
 arch/powerpc/boot/dts/tqm8540.dts                  |   28 +
 arch/powerpc/boot/dts/tqm8541.dts                  |   18 +
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |   44 +
 arch/powerpc/boot/dts/tqm8548.dts                  |   44 +
 arch/powerpc/boot/dts/tqm8555.dts                  |   18 +
 arch/powerpc/boot/dts/tqm8560.dts                  |   18 +
 arch/powerpc/sysdev/fsl_soc.c                      |  241 +-
 arch/s390/appldata/appldata_net_sum.c              |    4 +-
 arch/sparc64/kernel/idprom.c                       |    5 +-
 arch/um/drivers/daemon_kern.c                      |    2 +-
 arch/um/drivers/mcast_kern.c                       |    2 +-
 arch/um/drivers/net_kern.c                         |   29 +-
 arch/um/drivers/pcap_kern.c                        |    2 +-
 arch/um/drivers/slip_kern.c                        |    2 +-
 arch/um/drivers/slirp_kern.c                       |    2 +-
 arch/um/drivers/vde_kern.c                         |    2 +-
 arch/um/os-Linux/drivers/ethertap_kern.c           |    2 +-
 arch/um/os-Linux/drivers/tuntap_kern.c             |    2 +-
 arch/xtensa/platforms/iss/network.c                |   21 +-
 drivers/atm/Kconfig                                |    6 +
 drivers/atm/Makefile                               |    1 +
 drivers/atm/solos-pci.c                            |  790 ++
 drivers/block/aoe/aoe.h                            |    1 -
 drivers/block/aoe/aoeblk.c                         |    2 +-
 drivers/block/aoe/aoecmd.c                         |   22 +-
 drivers/block/aoe/aoenet.c                         |   11 -
 drivers/bluetooth/Kconfig                          |   20 -
 drivers/bluetooth/Makefile                         |    1 -
 drivers/bluetooth/bcm203x.c                        |    9 +-
 drivers/bluetooth/bfusb.c                          |   11 +-
 drivers/bluetooth/bpa10x.c                         |    7 +-
 drivers/bluetooth/bt3c_cs.c                        |    8 +-
 drivers/bluetooth/btsdio.c                         |    6 +-
 drivers/bluetooth/btusb.c                          |  229 +-
 drivers/bluetooth/hci_bcsp.c                       |    5 -
 drivers/bluetooth/hci_h4.c                         |    5 -
 drivers/bluetooth/hci_ldisc.c                      |    9 +-
 drivers/bluetooth/hci_usb.c                        | 1136 ---
 drivers/bluetooth/hci_usb.h                        |  129 -
 drivers/bluetooth/hci_vhci.c                       |    5 -
 drivers/firmware/iscsi_ibft.c                      |    7 +-
 drivers/infiniband/core/sysfs.c                    |   10 +-
 drivers/infiniband/hw/amso1100/c2_provider.c       |    8 +-
 drivers/infiniband/hw/mthca/mthca_mcg.c            |   23 +-
 drivers/infiniband/hw/nes/nes.c                    |   17 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   31 +-
 drivers/infiniband/hw/nes/nes_hw.c                 |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   13 +-
 drivers/infiniband/hw/nes/nes_utils.c              |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   23 -
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   25 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   70 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |    8 +-
 drivers/infiniband/ulp/srp/ib_srp.c                |   31 +-
 drivers/isdn/gigaset/asyncdata.c                   |   18 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |   13 +-
 drivers/isdn/gigaset/common.c                      |   21 +-
 drivers/isdn/gigaset/ev-layer.c                    |   42 +-
 drivers/isdn/gigaset/gigaset.h                     |   20 +-
 drivers/isdn/gigaset/i4l.c                         |    4 +-
 drivers/isdn/gigaset/interface.c                   |   52 +-
 drivers/isdn/gigaset/isocdata.c                    |    6 +-
 drivers/isdn/gigaset/ser-gigaset.c                 |   32 +-
 drivers/isdn/gigaset/usb-gigaset.c                 |   14 +-
 drivers/isdn/hardware/eicon/di.c                   |   28 +-
 drivers/isdn/hardware/eicon/message.c              |   60 +-
 drivers/isdn/hardware/mISDN/hfc_multi.h            |    4 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   67 +-
 drivers/isdn/hysdn/hysdn_net.c                     |    6 +-
 drivers/isdn/i4l/isdn_concap.c                     |    4 +-
 drivers/isdn/i4l/isdn_net.c                        |  224 +-
 drivers/isdn/i4l/isdn_net.h                        |   50 +-
 drivers/isdn/i4l/isdn_ppp.c                        |   32 +-
 drivers/isdn/mISDN/core.c                          |    8 +-
 drivers/isdn/mISDN/dsp_audio.c                     |    2 +-
 drivers/isdn/mISDN/dsp_cmx.c                       |    8 +-
 drivers/isdn/mISDN/dsp_core.c                      |    4 +-
 drivers/isdn/mISDN/dsp_hwec.c                      |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |    2 +-
 drivers/isdn/mISDN/dsp_tones.c                     |   92 +-
 drivers/isdn/mISDN/l1oip_codec.c                   |    1 +
 drivers/isdn/mISDN/l1oip_core.c                    |   22 +-
 drivers/isdn/mISDN/layer1.c                        |    3 +-
 drivers/isdn/mISDN/layer2.c                        |   16 +-
 drivers/isdn/mISDN/socket.c                        |    2 +-
 drivers/isdn/mISDN/stack.c                         |    2 +-
 drivers/isdn/mISDN/tei.c                           |    4 +-
 drivers/isdn/mISDN/timerdev.c                      |    9 +-
 drivers/media/dvb/b2c2/flexcop.c                   |    2 +-
 drivers/media/dvb/bt8xx/dst.c                      |    4 +-
 drivers/media/dvb/dm1105/dm1105.c                  |    3 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |   37 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c            |    5 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    3 +-
 drivers/message/fusion/mptlan.c                    |   22 +-
 drivers/message/fusion/mptlan.h                    |    2 +-
 drivers/misc/sgi-xp/xpnet.c                        |   13 +-
 drivers/net/3c501.c                                |    3 +-
 drivers/net/3c501.h                                |    2 +-
 drivers/net/3c503.c                                |   21 +-
 drivers/net/3c505.c                                |   51 +-
 drivers/net/3c507.c                                |   15 +-
 drivers/net/3c509.c                                |    6 +-
 drivers/net/3c515.c                                |   13 +-
 drivers/net/3c523.c                                |   46 +-
 drivers/net/3c527.c                                |    4 +-
 drivers/net/3c59x.c                                |   13 +-
 drivers/net/7990.c                                 |    1 -
 drivers/net/8139cp.c                               |   47 +-
 drivers/net/8139too.c                              |   57 +-
 drivers/net/82596.c                                |   48 +-
 drivers/net/8390.c                                 |   50 +-
 drivers/net/8390.h                                 |   15 +
 drivers/net/8390p.c                                |   50 +-
 drivers/net/Kconfig                                |   64 +-
 drivers/net/Makefile                               |   11 +-
 drivers/net/a2065.c                                |    5 +-
 drivers/net/ac3200.c                               |    5 +-
 drivers/net/acenic.c                               |   37 +-
 drivers/net/amd8111e.c                             |   12 +-
 drivers/net/apne.c                                 |   29 +-
 drivers/net/appletalk/cops.c                       |    9 -
 drivers/net/appletalk/ipddp.c                      |    6 +-
 drivers/net/appletalk/ltpc.c                       |   13 +-
 drivers/net/arcnet/arc-rawmode.c                   |    5 +-
 drivers/net/arcnet/arc-rimi.c                      |   16 +-
 drivers/net/arcnet/arcnet.c                        |   32 +-
 drivers/net/arcnet/capmode.c                       |    9 +-
 drivers/net/arcnet/com20020-isa.c                  |    4 +-
 drivers/net/arcnet/com20020-pci.c                  |    2 +-
 drivers/net/arcnet/com20020.c                      |   10 +-
 drivers/net/arcnet/com90io.c                       |    4 +-
 drivers/net/arcnet/com90xx.c                       |   12 +-
 drivers/net/arcnet/rfc1051.c                       |    9 +-
 drivers/net/arcnet/rfc1201.c                       |   14 +-
 drivers/net/ariadne.c                              |   21 +-
 drivers/net/arm/Kconfig                            |   10 +-
 drivers/net/arm/Makefile                           |    3 +-
 drivers/net/arm/am79c961a.c                        |    7 +-
 drivers/net/arm/at91_ether.c                       |   11 +-
 drivers/net/arm/ep93xx_eth.c                       |    8 +-
 drivers/net/arm/ether1.c                           |    5 +-
 drivers/net/arm/ether3.c                           |    5 +-
 drivers/net/arm/etherh.c                           |   24 +-
 drivers/net/arm/ixp4xx_eth.c                       |  344 +-
 drivers/net/arm/ks8695net.c                        | 1676 ++++
 drivers/net/arm/ks8695net.h                        |  107 +
 drivers/net/at1700.c                               |   16 +-
 drivers/net/atarilance.c                           |   52 +-
 drivers/net/atl1e/atl1e_main.c                     |   47 +-
 drivers/net/atlx/atl1.c                            |  102 +-
 drivers/net/atlx/atl1.h                            |    4 +-
 drivers/net/atlx/atl2.c                            |  101 +-
 drivers/net/atlx/atl2.h                            |    1 -
 drivers/net/atlx/atlx.c                            |   13 -
 drivers/net/atp.c                                  |   29 +-
 drivers/net/au1000_eth.c                           |   50 +-
 drivers/net/ax88796.c                              |    9 +-
 drivers/net/b44.c                                  |   13 +-
 drivers/net/bfin_mac.c                             |    1 -
 drivers/net/bmac.c                                 |    7 +-
 drivers/net/bnx2.c                                 |   94 +-
 drivers/net/bnx2.h                                 |   42 +-
 drivers/net/bnx2x_link.c                           |   72 +-
 drivers/net/bnx2x_link.h                           |   10 +-
 drivers/net/bnx2x_main.c                           |   95 +-
 drivers/net/bonding/Makefile                       |    3 +
 drivers/net/bonding/bond_3ad.c                     |  667 +-
 drivers/net/bonding/bond_3ad.h                     |   59 +-
 drivers/net/bonding/bond_alb.c                     |   37 +-
 drivers/net/bonding/bond_ipv6.c                    |  216 +
 drivers/net/bonding/bond_main.c                    |  477 +-
 drivers/net/bonding/bond_sysfs.c                   |  160 +-
 drivers/net/bonding/bonding.h                      |   68 +-
 drivers/net/can/vcan.c                             |   24 +-
 drivers/net/cassini.c                              |   16 +-
 drivers/net/chelsio/cxgb2.c                        |   94 +-
 drivers/net/chelsio/sge.c                          |   10 +-
 drivers/net/cpmac.c                                |   15 +-
 drivers/net/cris/eth_v10.c                         |    4 +-
 drivers/net/cs89x0.c                               |   16 +-
 drivers/net/cxgb3/adapter.h                        |    5 +-
 drivers/net/cxgb3/common.h                         |    4 +-
 drivers/net/cxgb3/cxgb3_ctl_defs.h                 |   17 +
 drivers/net/cxgb3/cxgb3_main.c                     |  130 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |   76 +-
 drivers/net/cxgb3/sge.c                            |  105 +-
 drivers/net/cxgb3/t3_hw.c                          |   26 +-
 drivers/net/cxgb3/version.h                        |    2 +-
 drivers/net/cxgb3/vsc8211.c                        |    2 +
 drivers/net/de600.c                                |    4 +-
 drivers/net/de620.c                                |   26 +-
 drivers/net/declance.c                             |    7 +-
 drivers/net/defxx.c                                |   27 +-
 drivers/net/depca.c                                |   54 +-
 drivers/net/dl2k.c                                 |   28 +-
 drivers/net/dm9000.c                               |   40 +-
 drivers/net/dummy.c                                |   15 +-
 drivers/net/e100.c                                 |   68 +-
 drivers/net/e1000/e1000.h                          |    1 -
 drivers/net/e1000/e1000_main.c                     |  107 +-
 drivers/net/e1000e/82571.c                         |   19 +-
 drivers/net/e1000e/defines.h                       |    8 +
 drivers/net/e1000e/e1000.h                         |    2 +
 drivers/net/e1000e/es2lan.c                        |  194 +-
 drivers/net/e1000e/ethtool.c                       |   82 +-
 drivers/net/e1000e/hw.h                            |    8 +-
 drivers/net/e1000e/ich8lan.c                       |  151 +-
 drivers/net/e1000e/lib.c                           |   80 +-
 drivers/net/e1000e/netdev.c                        |  131 +-
 drivers/net/e1000e/phy.c                           |   12 +-
 drivers/net/e2100.c                                |   24 +-
 drivers/net/eepro.c                                |   10 +-
 drivers/net/eepro100.c                             | 2401 ------
 drivers/net/eexpress.c                             |    3 +-
 drivers/net/ehea/ehea.h                            |    2 +-
 drivers/net/ehea/ehea_main.c                       |    7 +-
 drivers/net/ehea/ehea_qmr.c                        |   18 +-
 drivers/net/enc28j60.c                             |   49 +-
 drivers/net/enic/cq_desc.h                         |    5 +-
 drivers/net/enic/enic.h                            |    2 +-
 drivers/net/enic/enic_main.c                       |   86 +-
 drivers/net/enic/enic_res.c                        |    7 +-
 drivers/net/enic/enic_res.h                        |    4 -
 drivers/net/enic/vnic_dev.c                        |   70 +-
 drivers/net/enic/vnic_devcmd.h                     |   19 +-
 drivers/net/enic/vnic_intr.h                       |    2 +-
 drivers/net/enic/vnic_resource.h                   |    2 +-
 drivers/net/enic/vnic_rq.h                         |    9 +-
 drivers/net/enic/vnic_rss.h                        |   13 +
 drivers/net/enic/vnic_wq.h                         |    9 +-
 drivers/net/epic100.c                              |   56 +-
 drivers/net/eql.c                                  |   12 +-
 drivers/net/es3210.c                               |   34 +-
 drivers/net/eth16i.c                               |   15 +-
 drivers/net/ewrk3.c                                |   18 +-
 drivers/net/fealnx.c                               |    6 +-
 drivers/net/fec.c                                  |    6 +-
 drivers/net/fec_mpc52xx.c                          |    3 +-
 drivers/net/forcedeth.c                            |   90 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    9 +-
 drivers/net/gianfar.c                              |  861 ++-
 drivers/net/gianfar.h                              |   78 +-
 drivers/net/gianfar_ethtool.c                      |   89 +-
 drivers/net/gianfar_mii.c                          |  212 +-
 drivers/net/gianfar_mii.h                          |    2 +
 drivers/net/hamachi.c                              |   27 +-
 drivers/net/hamradio/6pack.c                       |    1 -
 drivers/net/hamradio/baycom_epp.c                  |    1 -
 drivers/net/hamradio/bpqether.c                    |    8 +-
 drivers/net/hamradio/dmascc.c                      |   13 +-
 drivers/net/hamradio/hdlcdrv.c                     |    1 -
 drivers/net/hamradio/mkiss.c                       |    4 +-
 drivers/net/hamradio/scc.c                         |   13 +-
 drivers/net/hamradio/yam.c                         |    1 -
 drivers/net/hp-plus.c                              |   27 +-
 drivers/net/hp.c                                   |   25 +-
 drivers/net/hp100.c                                |   24 +-
 drivers/net/hydra.c                                |   28 +-
 drivers/net/ibm_newemac/core.c                     |   11 +-
 drivers/net/ibmlana.c                              |    6 +-
 drivers/net/ibmveth.c                              |   46 +-
 drivers/net/ifb.c                                  |   13 +-
 drivers/net/igb/e1000_defines.h                    |    7 +-
 drivers/net/igb/e1000_mac.c                        |   25 +-
 drivers/net/igb/e1000_regs.h                       |    4 +
 drivers/net/igb/igb.h                              |   44 +-
 drivers/net/igb/igb_ethtool.c                      |  131 +-
 drivers/net/igb/igb_main.c                         |  403 +-
 drivers/net/ioc3-eth.c                             |   13 +-
 drivers/net/ipg.c                                  |    9 -
 drivers/net/irda/ali-ircc.c                        |   17 +-
 drivers/net/irda/au1k_ir.c                         |    1 -
 drivers/net/irda/donauboe.c                        |    8 +-
 drivers/net/irda/irda-usb.c                        |   15 +-
 drivers/net/irda/irtty-sir.c                       |    7 +-
 drivers/net/irda/kingsun-sir.c                     |    1 -
 drivers/net/irda/ks959-sir.c                       |    1 -
 drivers/net/irda/ksdazzle-sir.c                    |    1 -
 drivers/net/irda/ma600-sir.c                       |    2 +-
 drivers/net/irda/mcs7780.c                         |    1 -
 drivers/net/irda/nsc-ircc.c                        |   17 +-
 drivers/net/irda/pxaficp_ir.c                      |    4 -
 drivers/net/irda/sa1100_ir.c                       |   28 +-
 drivers/net/irda/sir_dev.c                         |   12 +-
 drivers/net/irda/smsc-ircc2.c                      |    6 +-
 drivers/net/irda/stir4200.c                        |    1 -
 drivers/net/irda/via-ircc.c                        |   16 +-
 drivers/net/irda/vlsi_ir.c                         |   37 +-
 drivers/net/irda/w83977af_ir.c                     |   29 +-
 drivers/net/isa-skeleton.c                         |   16 +-
 drivers/net/iseries_veth.c                         |   14 +-
 drivers/net/ixgb/ixgb_main.c                       |   58 +-
 drivers/net/ixgbe/Makefile                         |    2 +
 drivers/net/ixgbe/ixgbe.h                          |   32 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |  192 +-
 drivers/net/ixgbe/ixgbe_dcb.c                      |  332 +
 drivers/net/ixgbe/ixgbe_dcb.h                      |  184 +
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |  398 +
 drivers/net/ixgbe/ixgbe_dcb_82598.h                |   94 +
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |  641 ++
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  134 +-
 drivers/net/ixgbe/ixgbe_main.c                     |  485 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |  326 +
 drivers/net/ixgbe/ixgbe_phy.h                      |   25 +
 drivers/net/ixgbe/ixgbe_type.h                     |   28 +-
 drivers/net/ixp2000/ixpdev.c                       |    6 +-
 drivers/net/jazzsonic.c                            |    4 +-
 drivers/net/jme.c                                  |   71 +-
 drivers/net/jme.h                                  |   34 +-
 drivers/net/korina.c                               |    5 +-
 drivers/net/lance.c                                |   32 +-
 drivers/net/lib82596.c                             |   14 +-
 drivers/net/lib8390.c                              |   20 +-
 drivers/net/lne390.c                               |   29 +-
 drivers/net/loopback.c                             |   29 +-
 drivers/net/lp486e.c                               |   29 +-
 drivers/net/mac8390.c                              |   22 +-
 drivers/net/mac89x0.c                              |   16 +-
 drivers/net/macb.c                                 |   18 +-
 drivers/net/mace.c                                 |   34 +-
 drivers/net/macmace.c                              |    6 +-
 drivers/net/macsonic.c                             |    9 +-
 drivers/net/macvlan.c                              |   49 +-
 drivers/net/meth.c                                 |    4 +-
 drivers/net/mlx4/en_cq.c                           |    4 +-
 drivers/net/mlx4/en_netdev.c                       |   48 +-
 drivers/net/mlx4/en_params.c                       |   20 +-
 drivers/net/mlx4/en_rx.c                           |    9 +-
 drivers/net/mlx4/en_tx.c                           |   29 +-
 drivers/net/mlx4/mcg.c                             |   25 +-
 drivers/net/mlx4/mlx4_en.h                         |   12 +-
 drivers/net/mv643xx_eth.c                          |  525 +-
 drivers/net/mvme147.c                              |    9 +-
 drivers/net/myri10ge/myri10ge.c                    |   71 +-
 drivers/net/myri10ge/myri10ge_mcp.h                |  175 +-
 drivers/net/myri10ge/myri10ge_mcp_gen_header.h     |    2 +
 drivers/net/myri_sbus.c                            |   27 +-
 drivers/net/natsemi.c                              |   12 +-
 drivers/net/ne-h8300.c                             |   30 +-
 drivers/net/ne.c                                   |   29 +-
 drivers/net/ne2.c                                  |   29 +-
 drivers/net/ne2k-pci.c                             |   28 +-
 drivers/net/ne3210.c                               |   31 +-
 drivers/net/netconsole.c                           |    9 +-
 drivers/net/netx-eth.c                             |    1 -
 drivers/net/netxen/netxen_nic_ethtool.c            |   10 +-
 drivers/net/netxen/netxen_nic_hw.c                 |    6 +-
 drivers/net/netxen/netxen_nic_init.c               |    2 -
 drivers/net/netxen/netxen_nic_main.c               |   57 +-
 drivers/net/netxen/netxen_nic_niu.c                |    7 +-
 drivers/net/ni5010.c                               |   15 +-
 drivers/net/ni52.c                                 |   43 +-
 drivers/net/ni65.c                                 |   39 +-
 drivers/net/niu.c                                  |  145 +-
 drivers/net/niu.h                                  |    2 +-
 drivers/net/ns83820.c                              |   28 +-
 drivers/net/pasemi_mac.c                           |   14 +-
 drivers/net/pasemi_mac_ethtool.c                   |    4 +-
 drivers/net/pci-skeleton.c                         |    8 +-
 drivers/net/pcmcia/3c574_cs.c                      |    6 +-
 drivers/net/pcmcia/3c589_cs.c                      |    6 +-
 drivers/net/pcmcia/axnet_cs.c                      |   22 +-
 drivers/net/pcmcia/com20020_cs.c                   |    6 +-
 drivers/net/pcmcia/fmvj18x_cs.c                    |   79 +-
 drivers/net/pcmcia/nmclan_cs.c                     |    6 +-
 drivers/net/pcmcia/pcnet_cs.c                      |    3 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |    5 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |    6 +-
 drivers/net/pcnet32.c                              |   10 +-
 drivers/net/phy/Kconfig                            |   23 +-
 drivers/net/phy/Makefile                           |    5 +-
 drivers/net/phy/broadcom.c                         |  216 +-
 drivers/net/phy/et1011c.c                          |  113 +
 drivers/net/phy/mdio-gpio.c                        |  296 +
 drivers/net/phy/mdio-ofgpio.c                      |  204 -
 drivers/net/phy/mdio_bus.c                         |   40 +-
 drivers/net/phy/national.c                         |  155 +
 drivers/net/phy/phy.c                              |    2 +-
 drivers/net/phy/phy_device.c                       |   54 +-
 drivers/net/phy/smsc.c                             |   28 +
 drivers/net/phy/ste10Xp.c                          |  137 +
 drivers/net/plip.c                                 |   35 +-
 drivers/net/ppp_async.c                            |    6 -
 drivers/net/ppp_generic.c                          |  206 +-
 drivers/net/ppp_synctty.c                          |    6 -
 drivers/net/pppoe.c                                |    5 +-
 drivers/net/pppol2tp.c                             |   94 +-
 drivers/net/ps3_gelic_net.c                        |    6 +-
 drivers/net/ps3_gelic_wireless.c                   |   37 +-
 drivers/net/ps3_gelic_wireless.h                   |    4 +-
 drivers/net/qla3xxx.c                              |   42 +-
 drivers/net/qlge/qlge_ethtool.c                    |    2 +-
 drivers/net/qlge/qlge_main.c                       |   79 +-
 drivers/net/qlge/qlge_mpi.c                        |    2 +-
 drivers/net/r6040.c                                |   51 +-
 drivers/net/r8169.c                                |   57 +-
 drivers/net/rionet.c                               |   31 +-
 drivers/net/rrunner.c                              |   25 +-
 drivers/net/s2io.c                                 |  146 +-
 drivers/net/sb1000.c                               |    1 -
 drivers/net/sb1250-mac.c                           |   11 +-
 drivers/net/sc92031.c                              |   30 +-
 drivers/net/seeq8005.c                             |   13 +-
 drivers/net/sfc/Kconfig                            |    8 +
 drivers/net/sfc/Makefile                           |    5 +-
 drivers/net/sfc/boards.c                           |  206 +-
 drivers/net/sfc/boards.h                           |   14 +-
 drivers/net/sfc/efx.c                              |  449 +-
 drivers/net/sfc/efx.h                              |   12 +-
 drivers/net/sfc/enum.h                             |   36 +-
 drivers/net/sfc/ethtool.c                          |  175 +-
 drivers/net/sfc/falcon.c                           |  476 +-
 drivers/net/sfc/falcon.h                           |    3 +
 drivers/net/sfc/falcon_gmac.c                      |  229 +
 drivers/net/sfc/falcon_hwdefs.h                    |  161 +-
 drivers/net/sfc/falcon_xmac.c                      |  261 +-
 drivers/net/sfc/gmii.h                             |  137 +-
 drivers/net/sfc/mac.h                              |   16 +-
 drivers/net/sfc/mdio_10g.c                         |  483 +-
 drivers/net/sfc/mdio_10g.h                         |   63 +-
 drivers/net/sfc/mtd.c                              |  268 +
 drivers/net/sfc/net_driver.h                       |  131 +-
 drivers/net/sfc/phy.h                              |    7 +-
 drivers/net/sfc/rx.c                               |    2 +-
 drivers/net/sfc/selftest.c                         |  145 +-
 drivers/net/sfc/selftest.h                         |   14 +-
 drivers/net/sfc/sfe4001.c                          |  225 +-
 drivers/net/sfc/spi.h                              |   34 +-
 drivers/net/sfc/tenxpress.c                        |  796 ++-
 drivers/net/sfc/workarounds.h                      |   12 +-
 drivers/net/sfc/xfp_phy.c                          |   29 +-
 drivers/net/sgiseeq.c                              |    7 +-
 drivers/net/sh_eth.c                               |    3 +-
 drivers/net/sis190.c                               |    7 +-
 drivers/net/sis900.c                               |   99 +-
 drivers/net/skfp/skfddi.c                          |   27 +-
 drivers/net/skge.c                                 |  103 +-
 drivers/net/sky2.c                                 |   56 +-
 drivers/net/slip.c                                 |   12 +-
 drivers/net/smc-mca.c                              |   27 +-
 drivers/net/smc-ultra.c                            |   27 +-
 drivers/net/smc-ultra32.c                          |    5 +-
 drivers/net/smc911x.c                              |   16 +-
 drivers/net/smc9194.c                              |   13 +-
 drivers/net/smc91x.c                               |   42 +-
 drivers/net/smc91x.h                               |   58 +-
 drivers/net/smsc911x.c                             | 2071 +++++
 drivers/net/smsc911x.h                             |  390 +
 drivers/net/smsc9420.c                             | 1744 ++++
 drivers/net/smsc9420.h                             |  275 +
 drivers/net/sonic.c                                |    1 -
 drivers/net/sonic.h                                |   20 +-
 drivers/net/spider_net.c                           |   17 +-
 drivers/net/spider_net_ethtool.c                   |    8 +-
 drivers/net/starfire.c                             |   24 +-
 drivers/net/stnic.c                                |   25 +-
 drivers/net/sun3_82586.c                           |   40 +-
 drivers/net/sun3lance.c                            |   10 +-
 drivers/net/sunbmac.c                              |   22 +-
 drivers/net/sundance.c                             |    6 +-
 drivers/net/sungem.c                               |   65 +-
 drivers/net/sunhme.c                               |   31 +-
 drivers/net/sunlance.c                             |    7 +-
 drivers/net/sunqe.c                                |   15 +-
 drivers/net/sunvnet.c                              |    5 +-
 drivers/net/tc35815.c                              |   49 +-
 drivers/net/tehuti.c                               |   73 +-
 drivers/net/tg3.c                                  | 1068 ++-
 drivers/net/tg3.h                                  |  188 +-
 drivers/net/tlan.c                                 |  213 +-
 drivers/net/tokenring/3c359.c                      |   13 +-
 drivers/net/tokenring/Kconfig                      |    2 +-
 drivers/net/tokenring/abyss.c                      |    4 +-
 drivers/net/tokenring/ibmtr.c                      |   15 +-
 drivers/net/tokenring/lanstreamer.c                |   36 +-
 drivers/net/tokenring/madgemc.c                    |   12 +-
 drivers/net/tokenring/olympic.c                    |   52 +-
 drivers/net/tokenring/proteon.c                    |    7 +-
 drivers/net/tokenring/skisa.c                      |    7 +-
 drivers/net/tokenring/smctr.c                      |    2 -
 drivers/net/tokenring/tms380tr.c                   |   15 +-
 drivers/net/tokenring/tmspci.c                     |    5 +-
 drivers/net/tsi108_eth.c                           |   12 +-
 drivers/net/tulip/de2104x.c                        |   54 +-
 drivers/net/tulip/de4x5.c                          |   17 +-
 drivers/net/tulip/dmfe.c                           |    7 +-
 drivers/net/tulip/eeprom.c                         |    2 +-
 drivers/net/tulip/interrupt.c                      |   10 +-
 drivers/net/tulip/tulip_core.c                     |   15 +-
 drivers/net/tulip/uli526x.c                        |    8 +-
 drivers/net/tulip/winbond-840.c                    |   16 +-
 drivers/net/tulip/xircom_cb.c                      |    4 +-
 drivers/net/tun.c                                  |   33 +-
 drivers/net/typhoon.c                              |   15 +-
 drivers/net/ucc_geth.c                             |  408 +-
 drivers/net/ucc_geth.h                             |    1 +
 drivers/net/usb/asix.c                             |    5 +-
 drivers/net/usb/catc.c                             |   43 +-
 drivers/net/usb/dm9601.c                           |    5 +-
 drivers/net/usb/hso.c                              |   34 +-
 drivers/net/usb/kaweth.c                           |   17 +-
 drivers/net/usb/mcs7830.c                          |    9 +-
 drivers/net/usb/pegasus.c                          |   74 +-
 drivers/net/usb/rtl8150.c                          |   38 +-
 drivers/net/usb/smsc95xx.c                         |  110 +-
 drivers/net/usb/usbnet.c                           |    5 +-
 drivers/net/veth.c                                 |   30 +-
 drivers/net/via-rhine.c                            |   47 +-
 drivers/net/via-velocity.c                         |   28 +-
 drivers/net/virtio_net.c                           |  217 +-
 drivers/net/wan/Kconfig                            |    9 +
 drivers/net/wan/Makefile                           |    3 +-
 drivers/net/wan/c101.c                             |    6 +-
 drivers/net/wan/cosa.c                             |    1 -
 drivers/net/wan/cycx_x25.c                         |   91 +-
 drivers/net/wan/dlci.c                             |   37 +-
 drivers/net/wan/dscc4.c                            |    4 +-
 drivers/net/wan/farsync.c                          |    2 -
 drivers/net/wan/{hd6457x.c => hd64570.c}           |  255 +-
 drivers/net/wan/hd64572.c                          |  640 ++
 drivers/net/wan/hdlc_fr.c                          |   10 +-
 drivers/net/wan/hdlc_ppp.c                         |  649 ++-
 drivers/net/wan/hostess_sv11.c                     |    1 -
 drivers/net/wan/ixp4xx_hss.c                       | 1325 +++
 drivers/net/wan/lapbether.c                        |    3 -
 drivers/net/wan/lmc/lmc_main.c                     |    1 -
 drivers/net/wan/lmc/lmc_proto.c                    |    1 -
 drivers/net/wan/n2.c                               |    9 +-
 drivers/net/wan/pc300_drv.c                        |   22 +-
 drivers/net/wan/pc300too.c                         |  121 +-
 drivers/net/wan/pci200syn.c                        |   79 +-
 drivers/net/wan/sbni.c                             |  101 +-
 drivers/net/wan/sdla.c                             |   48 +-
 drivers/net/wan/sealevel.c                         |    1 -
 drivers/net/wan/syncppp.c                          | 1480 ----
 drivers/net/wan/wanxl.c                            |    9 +-
 drivers/net/wan/x25_asy.c                          |   52 +-
 drivers/net/wan/z85230.c                           |   12 +-
 drivers/net/wd.c                                   |   29 +-
 drivers/net/wireless/Kconfig                       |  163 +-
 drivers/net/wireless/Makefile                      |   22 +-
 drivers/net/wireless/adm8211.c                     |   52 +-
 drivers/net/wireless/adm8211.h                     |    2 -
 drivers/net/wireless/airo.c                        |  243 +-
 drivers/net/wireless/arlan-main.c                  |   27 +-
 drivers/net/wireless/ath5k/ath5k.h                 |  102 +-
 drivers/net/wireless/ath5k/attach.c                |   14 +-
 drivers/net/wireless/ath5k/base.c                  |  191 +-
 drivers/net/wireless/ath5k/desc.c                  |    4 +-
 drivers/net/wireless/ath5k/dma.c                   |  190 +-
 drivers/net/wireless/ath5k/eeprom.c                | 1194 +++-
 drivers/net/wireless/ath5k/eeprom.h                |  253 +-
 drivers/net/wireless/ath5k/initvals.c              |    8 +-
 drivers/net/wireless/ath5k/pcu.c                   |  233 +-
 drivers/net/wireless/ath5k/phy.c                   |    9 +-
 drivers/net/wireless/ath5k/qcu.c                   |   37 +-
 drivers/net/wireless/ath5k/reg.h                   |   16 +-
 drivers/net/wireless/ath5k/reset.c                 |    9 +-
 drivers/net/wireless/ath9k/Kconfig                 |   11 +
 drivers/net/wireless/ath9k/Makefile                |    9 +-
 drivers/net/wireless/ath9k/ani.c                   |  852 ++
 drivers/net/wireless/ath9k/ath9k.h                 |  432 +-
 drivers/net/wireless/ath9k/beacon.c                |  319 +-
 drivers/net/wireless/ath9k/calib.c                 | 1021 +++
 drivers/net/wireless/ath9k/core.c                  | 1886 -----
 drivers/net/wireless/ath9k/core.h                  |  926 +--
 drivers/net/wireless/ath9k/debug.c                 |  262 +
 drivers/net/wireless/ath9k/eeprom.c                | 2824 +++++++
 drivers/net/wireless/ath9k/hw.c                    | 8490 +++++---------------
 drivers/net/wireless/ath9k/hw.h                    |  165 +-
 drivers/net/wireless/ath9k/initvals.h              | 1938 +++++-
 drivers/net/wireless/ath9k/mac.c                   |  946 +++
 drivers/net/wireless/ath9k/main.c                  | 2353 ++++--
 drivers/net/wireless/ath9k/phy.c                   |   24 +-
 drivers/net/wireless/ath9k/phy.h                   |    5 +
 drivers/net/wireless/ath9k/rc.c                    | 1832 ++---
 drivers/net/wireless/ath9k/rc.h                    |  220 +-
 drivers/net/wireless/ath9k/recv.c                  | 1242 +---
 drivers/net/wireless/ath9k/reg.h                   |  109 +-
 drivers/net/wireless/ath9k/regd.c                  |   85 +-
 drivers/net/wireless/ath9k/regd.h                  |    2 +-
 drivers/net/wireless/ath9k/xmit.c                  | 1532 ++--
 drivers/net/wireless/atmel.c                       |   79 +-
 drivers/net/wireless/b43/b43.h                     |    1 -
 drivers/net/wireless/b43/debugfs.c                 |    1 +
 drivers/net/wireless/b43/debugfs.h                 |    1 +
 drivers/net/wireless/b43/dma.c                     |    4 +-
 drivers/net/wireless/b43/main.c                    |  280 +-
 drivers/net/wireless/b43/phy_a.c                   |    4 +-
 drivers/net/wireless/b43/phy_common.c              |   18 +
 drivers/net/wireless/b43/phy_g.c                   |   28 +-
 drivers/net/wireless/b43/pio.c                     |    3 +-
 drivers/net/wireless/b43/xmit.c                    |   64 +-
 drivers/net/wireless/b43/xmit.h                    |    5 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |    5 +-
 drivers/net/wireless/b43legacy/debugfs.c           |    2 +-
 drivers/net/wireless/b43legacy/dma.c               |   48 +-
 drivers/net/wireless/b43legacy/main.c              |  211 +-
 drivers/net/wireless/b43legacy/phy.c               |    6 +-
 drivers/net/wireless/b43legacy/pio.c               |   31 +-
 drivers/net/wireless/b43legacy/xmit.c              |   26 +-
 drivers/net/wireless/b43legacy/xmit.h              |    2 +-
 drivers/net/wireless/hostap/Kconfig                |   13 +-
 drivers/net/wireless/hostap/hostap.h               |    2 +-
 drivers/net/wireless/hostap/hostap_80211.h         |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |   72 +-
 drivers/net/wireless/hostap/hostap_80211_tx.c      |   23 +-
 drivers/net/wireless/hostap/hostap_ap.c            |  253 +-
 drivers/net/wireless/hostap/hostap_ap.h            |    8 +-
 drivers/net/wireless/hostap/hostap_common.h        |   13 -
 drivers/net/wireless/hostap/hostap_hw.c            |   71 +-
 drivers/net/wireless/hostap/hostap_info.c          |   16 +-
 drivers/net/wireless/hostap/hostap_ioctl.c         |  157 +-
 drivers/net/wireless/hostap/hostap_main.c          |   45 +-
 drivers/net/wireless/hostap/hostap_pci.c           |    2 +-
 drivers/net/wireless/hostap/hostap_proc.c          |   35 +-
 drivers/net/wireless/hostap/hostap_wlan.h          |    8 +-
 drivers/net/wireless/ipw2x00/Kconfig               |  191 +
 drivers/net/wireless/ipw2x00/Makefile              |   14 +
 drivers/net/wireless/{ => ipw2x00}/ipw2100.c       |   71 +-
 drivers/net/wireless/{ => ipw2x00}/ipw2100.h       |    0 
 drivers/net/wireless/{ => ipw2x00}/ipw2200.c       |  482 +-
 drivers/net/wireless/{ => ipw2x00}/ipw2200.h       |    2 +
 .../net/wireless/ipw2x00/libipw_geo.c              |    0 
 .../net/wireless/ipw2x00/libipw_module.c           |   51 +-
 .../net/wireless/ipw2x00/libipw_rx.c               |  124 +-
 .../net/wireless/ipw2x00/libipw_tx.c               |    7 +-
 .../net/wireless/ipw2x00/libipw_wx.c               |   98 +-
 drivers/net/wireless/iwlwifi/Kconfig               |    2 +
 drivers/net/wireless/iwlwifi/Makefile              |    3 +-
 drivers/net/wireless/iwlwifi/iwl-3945-commands.h   |  148 +-
 drivers/net/wireless/iwlwifi/iwl-3945-core.h       |   28 +-
 drivers/net/wireless/iwlwifi/iwl-3945-debug.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-io.h         |   24 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c         |  223 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |  125 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |   40 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h         |  203 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |  251 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |   64 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  440 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c  |  108 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |  179 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |   22 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1241 +--
 drivers/net/wireless/iwlwifi/iwl-calib.c           |   19 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  536 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  335 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   78 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    8 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |   33 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |   83 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  183 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |   50 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |  173 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |  111 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |   37 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |    7 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |   38 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.c          |   12 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |  230 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  131 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c        |  198 +
 drivers/net/wireless/iwlwifi/iwl-spectrum.h        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  259 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |   16 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |  438 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |  751 +-
 drivers/net/wireless/libertas/assoc.c              |   69 +-
 drivers/net/wireless/libertas/cmd.c                |   32 +-
 drivers/net/wireless/libertas/cmd.h                |    3 +-
 drivers/net/wireless/libertas/debugfs.c            |   11 +-
 drivers/net/wireless/libertas/decl.h               |    4 -
 drivers/net/wireless/libertas/defs.h               |   14 +-
 drivers/net/wireless/libertas/dev.h                |    7 +-
 drivers/net/wireless/libertas/ethtool.c            |   14 +-
 drivers/net/wireless/libertas/host.h               |    9 +
 drivers/net/wireless/libertas/hostcmd.h            |   26 +-
 drivers/net/wireless/libertas/if_sdio.c            |    3 +-
 drivers/net/wireless/libertas/if_usb.c             |    7 +-
 drivers/net/wireless/libertas/main.c               |  135 +-
 drivers/net/wireless/libertas/persistcfg.c         |   18 +-
 drivers/net/wireless/libertas/radiotap.h           |    3 -
 drivers/net/wireless/libertas/scan.c               |  105 +-
 drivers/net/wireless/libertas/scan.h               |    4 +
 drivers/net/wireless/libertas/tx.c                 |    2 +-
 drivers/net/wireless/libertas/types.h              |    5 +-
 drivers/net/wireless/libertas/wext.c               |   80 +-
 drivers/net/wireless/libertas_tf/cmd.c             |    5 +-
 drivers/net/wireless/libertas_tf/main.c            |    8 +-
 drivers/net/wireless/mac80211_hwsim.c              |  294 +-
 drivers/net/wireless/netwave_cs.c                  |    6 +-
 drivers/net/wireless/orinoco/Makefile              |   12 +
 drivers/net/wireless/{ => orinoco}/airport.c       |    2 +-
 drivers/net/wireless/{ => orinoco}/hermes.c        |    0 
 drivers/net/wireless/{ => orinoco}/hermes.h        |    0 
 drivers/net/wireless/{ => orinoco}/hermes_dld.c    |    0 
 drivers/net/wireless/{ => orinoco}/hermes_dld.h    |    0 
 drivers/net/wireless/{ => orinoco}/hermes_rid.h    |    0 
 drivers/net/wireless/{ => orinoco}/orinoco.c       |  231 +-
 drivers/net/wireless/{ => orinoco}/orinoco.h       |    9 +
 drivers/net/wireless/{ => orinoco}/orinoco_cs.c    |   10 +-
 .../net/wireless/{ => orinoco}/orinoco_nortel.c    |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_pci.c   |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_pci.h   |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_plx.c   |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_tmd.c   |    0 
 drivers/net/wireless/{ => orinoco}/spectrum_cs.c   |   31 +-
 drivers/net/wireless/p54/p54.h                     |   74 +-
 drivers/net/wireless/p54/p54common.c               | 1620 +++-
 drivers/net/wireless/p54/p54common.h               |  349 +-
 drivers/net/wireless/p54/p54pci.c                  |   70 +-
 drivers/net/wireless/p54/p54pci.h                  |    2 +-
 drivers/net/wireless/p54/p54usb.c                  |  261 +-
 drivers/net/wireless/p54/p54usb.h                  |    1 +
 drivers/net/wireless/prism54/isl_ioctl.c           |   24 +-
 drivers/net/wireless/prism54/islpci_hotplug.c      |    8 +-
 drivers/net/wireless/ray_cs.c                      |   12 +-
 drivers/net/wireless/rndis_wlan.c                  |   95 +-
 drivers/net/wireless/rt2x00/Kconfig                |    1 +
 drivers/net/wireless/rt2x00/rt2400pci.c            |  373 +-
 drivers/net/wireless/rt2x00/rt2400pci.h            |    2 +
 drivers/net/wireless/rt2x00/rt2500pci.c            |  407 +-
 drivers/net/wireless/rt2x00/rt2500pci.h            |    2 +
 drivers/net/wireless/rt2x00/rt2500usb.c            |  443 +-
 drivers/net/wireless/rt2x00/rt2500usb.h            |    5 +
 drivers/net/wireless/rt2x00/rt2x00.h               |  113 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |  202 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |   79 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   47 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h          |   13 +
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   86 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c           |   88 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   33 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   56 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   41 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |   37 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   94 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   47 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |  145 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |  141 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |  469 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    2 +
 drivers/net/wireless/rt2x00/rt73usb.c              |  689 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    2 +
 drivers/net/wireless/rtl818x/Makefile              |    7 +
 drivers/net/wireless/{ => rtl818x}/rtl8180.h       |    0 
 drivers/net/wireless/{ => rtl818x}/rtl8180_dev.c   |   48 +-
 .../net/wireless/{ => rtl818x}/rtl8180_grf5101.c   |    0 
 .../net/wireless/{ => rtl818x}/rtl8180_grf5101.h   |    0 
 .../net/wireless/{ => rtl818x}/rtl8180_max2820.c   |    0 
 .../net/wireless/{ => rtl818x}/rtl8180_max2820.h   |    0 
 .../net/wireless/{ => rtl818x}/rtl8180_rtl8225.c   |   14 +-
 .../net/wireless/{ => rtl818x}/rtl8180_rtl8225.h   |    0 
 .../net/wireless/{ => rtl818x}/rtl8180_sa2400.c    |    0 
 .../net/wireless/{ => rtl818x}/rtl8180_sa2400.h    |    0 
 drivers/net/wireless/{ => rtl818x}/rtl8187.h       |    8 +-
 drivers/net/wireless/{ => rtl818x}/rtl8187_dev.c   |  459 +-
 .../net/wireless/{ => rtl818x}/rtl8187_rtl8225.c   |  397 +-
 .../net/wireless/{ => rtl818x}/rtl8187_rtl8225.h   |    0 
 drivers/net/wireless/{ => rtl818x}/rtl818x.h       |    1 +
 drivers/net/wireless/strip.c                       |   22 +-
 drivers/net/wireless/wavelan.c                     |  122 +-
 drivers/net/wireless/wavelan_cs.c                  |   39 +-
 drivers/net/wireless/wl3501.h                      |    4 +-
 drivers/net/wireless/wl3501_cs.c                   |   11 +-
 drivers/net/wireless/zd1201.c                      |  131 +-
 drivers/net/wireless/zd1211rw/zd_chip.c            |    4 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |   44 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |    2 +-
 drivers/net/xen-netfront.c                         |    9 +-
 drivers/net/xtsonic.c                              |    6 +-
 drivers/net/yellowfin.c                            |   42 +-
 drivers/net/znet.c                                 |   28 +-
 drivers/net/zorro8390.c                            |   29 +-
 drivers/parisc/led.c                               |    4 +-
 drivers/s390/net/lcs.c                             |   12 +-
 drivers/s390/net/qeth_core_offl.c                  |    8 +-
 drivers/s390/net/qeth_l2_main.c                    |   18 +-
 drivers/scsi/iscsi_tcp.c                           |    4 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    3 +-
 drivers/ssb/main.c                                 |   11 +-
 drivers/ssb/pcihost_wrapper.c                      |    2 +-
 drivers/staging/slicoss/slicoss.c                  |    7 +-
 drivers/staging/winbond/linux/wbusb.c              |    6 +-
 drivers/staging/wlan-ng/p80211netdev.c             |   20 +-
 drivers/staging/wlan-ng/p80211wext.c               |   58 +-
 drivers/usb/atm/cxacru.c                           |    4 +-
 drivers/usb/atm/usbatm.c                           |    5 +-
 drivers/usb/gadget/f_phonet.c                      |  621 ++
 drivers/usb/gadget/u_ether.c                       |   10 +-
 drivers/usb/gadget/u_phonet.h                      |   21 +
 drivers/uwb/wlp/eda.c                              |   38 +-
 firmware/Makefile                                  |    3 +
 firmware/WHENCE                                    |   11 +
 firmware/cxgb3/t3b_psram-1.1.0.bin.ihex            |  162 +
 firmware/cxgb3/t3c_psram-1.1.0.bin.ihex            |  162 +
 firmware/cxgb3/t3fw-7.0.0.bin.ihex                 | 1881 +++++
 fs/afs/proc.c                                      |    4 +-
 fs/afs/server.c                                    |    9 +-
 fs/cifs/cifs_spnego.c                              |    6 +-
 fs/cifs/connect.c                                  |    4 +-
 fs/dlm/netlink.c                                   |    2 +-
 fs/lockd/host.c                                    |    8 +-
 fs/lockd/mon.c                                     |    2 +-
 fs/nfs/nfsroot.c                                   |    6 +-
 fs/nfs/super.c                                     |    6 +-
 fs/nfsd/nfs4state.c                                |    4 +-
 fs/nfsd/nfsctl.c                                   |    2 +-
 fs/ocfs2/cluster/netdebug.c                        |    8 +-
 fs/ocfs2/cluster/nodemanager.c                     |    2 +-
 fs/ocfs2/cluster/tcp.c                             |   29 +-
 include/linux/atm.h                                |   17 +-
 include/linux/atmdev.h                             |   15 +
 include/linux/cgroup_subsys.h                      |    6 +
 include/linux/dcbnl.h                              |  340 +
 include/linux/dccp.h                               |   42 +-
 include/linux/etherdevice.h                        |   46 +
 include/linux/ethtool.h                            |    2 +
 include/linux/fddidevice.h                         |    1 +
 include/linux/filter.h                             |    3 +-
 include/linux/fsl_devices.h                        |   18 +-
 include/linux/hdlc.h                               |    4 +-
 include/linux/hippidevice.h                        |    4 +-
 include/linux/ieee80211.h                          |  212 +-
 include/linux/if.h                                 |    1 +
 include/linux/if_arp.h                             |    3 +
 include/linux/in.h                                 |    4 +
 include/linux/ipv6.h                               |    1 +
 include/linux/kernel.h                             |   12 -
 include/linux/list_nulls.h                         |   94 +
 include/linux/mdio-gpio.h                          |   25 +
 include/linux/mii.h                                |   33 +
 include/linux/mroute6.h                            |   26 +-
 include/linux/netdevice.h                          |  400 +-
 include/linux/netfilter_bridge/ebtables.h          |    3 +-
 include/linux/netfilter_ipv4/ipt_policy.h          |    2 +
 include/linux/netfilter_ipv6/ip6t_policy.h         |    2 +
 include/linux/netlink.h                            |    3 +-
 include/linux/netpoll.h                            |    5 -
 include/linux/nl80211.h                            |  223 +-
 include/linux/phy.h                                |    2 +
 include/linux/pkt_cls.h                            |   14 +
 include/linux/pkt_sched.h                          |   16 +
 include/linux/rculist_nulls.h                      |  110 +
 include/linux/rfkill.h                             |    8 +-
 include/linux/rtnetlink.h                          |    5 +
 include/linux/skbuff.h                             |   54 +-
 include/linux/smsc911x.h                           |   47 +
 include/linux/snmp.h                               |    3 +
 include/linux/sunrpc/svc_xprt.h                    |    8 +-
 include/linux/virtio_net.h                         |    9 +
 include/linux/xfrm.h                               |   14 +
 include/net/bluetooth/bluetooth.h                  |    4 +-
 include/net/bluetooth/hci.h                        |    2 +-
 include/net/cfg80211.h                             |  142 +-
 include/net/checksum.h                             |    2 +-
 include/net/dcbnl.h                                |   53 +
 include/net/dn.h                                   |    8 +-
 include/net/dn_fib.h                               |    6 +-
 include/net/dst.h                                  |   39 +-
 include/net/flow.h                                 |    9 +-
 include/net/gen_stats.h                            |    3 +-
 include/net/ieee80211.h                            |  148 +-
 include/net/ieee80211_radiotap.h                   |   15 +-
 include/net/inet_hashtables.h                      |   85 +-
 include/net/inet_timewait_sock.h                   |   10 +-
 include/net/ip.h                                   |    3 +-
 include/net/ip_vs.h                                |   17 +-
 include/net/{ieee80211_crypt.h => lib80211.h}      |   75 +-
 include/net/mac80211.h                             |  446 +-
 include/net/ndisc.h                                |   14 +
 include/net/neighbour.h                            |   15 +-
 include/net/net_namespace.h                        |   22 +
 include/net/netfilter/nf_conntrack.h               |    5 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   57 +-
 include/net/netfilter/nf_conntrack_expect.h        |    2 +
 include/net/netfilter/nf_conntrack_helper.h        |    5 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |    2 +-
 include/net/netfilter/nf_conntrack_tuple.h         |   12 +-
 include/net/netfilter/nfnetlink_log.h              |   14 +
 include/net/netlink.h                              |   24 +-
 include/net/netns/ipv4.h                           |    2 +
 include/net/netns/ipv6.h                           |   12 +
 include/net/netns/mib.h                            |    3 +
 include/net/netns/x_tables.h                       |    5 +
 include/net/netns/xfrm.h                           |   56 +
 include/net/phonet/pep.h                           |    2 +-
 include/net/phonet/phonet.h                        |    2 +-
 include/net/phonet/pn_dev.h                        |    2 +-
 include/net/pkt_cls.h                              |    2 +-
 include/net/protocol.h                             |    3 +
 include/net/sch_generic.h                          |   38 +-
 include/net/sctp/sctp.h                            |    9 +-
 include/net/sctp/user.h                            |    2 +
 include/net/sock.h                                 |   86 +-
 include/net/syncppp.h                              |  102 -
 include/net/tcp.h                                  |   20 +-
 include/net/udp.h                                  |   25 +-
 include/net/udplite.h                              |    2 +-
 include/net/wireless.h                             |   90 +-
 include/net/xfrm.h                                 |  110 +-
 lib/vsprintf.c                                     |   77 +
 net/802/fddi.c                                     |    8 +-
 net/802/hippi.c                                    |   14 +-
 net/802/tr.c                                       |   24 +-
 net/8021q/vlan.c                                   |   26 +-
 net/8021q/vlan.h                                   |    6 +-
 net/8021q/vlan_core.c                              |    2 -
 net/8021q/vlan_dev.c                               |   76 +-
 net/9p/trans_rdma.c                                |    2 -
 net/Kconfig                                        |    7 +-
 net/Makefile                                       |    4 +-
 net/appletalk/aarp.c                               |    3 +-
 net/appletalk/ddp.c                                |    5 +-
 net/appletalk/sysctl_net_atalk.c                   |   14 +-
 net/atm/atm_sysfs.c                                |    2 +-
 net/atm/br2684.c                                   |    7 +-
 net/atm/clip.c                                     |    4 +-
 net/atm/common.h                                   |    1 +
 net/atm/ioctl.c                                    |   49 +-
 net/atm/lec.c                                      |   60 +-
 net/atm/mpc.c                                      |   40 +-
 net/atm/mpoa_caches.c                              |   18 +-
 net/atm/pvc.c                                      |    3 +
 net/atm/resources.c                                |   88 +-
 net/atm/resources.h                                |    2 +-
 net/atm/svc.c                                      |   19 +
 net/ax25/ax25_in.c                                 |   41 +-
 net/ax25/sysctl_net_ax25.c                         |   58 +-
 net/bluetooth/af_bluetooth.c                       |   50 +-
 net/bluetooth/bnep/bnep.h                          |    2 +-
 net/bluetooth/bnep/core.c                          |    8 +-
 net/bluetooth/bnep/netdev.c                        |   11 +-
 net/bluetooth/bnep/sock.c                          |    5 -
 net/bluetooth/cmtp/capi.c                          |    5 -
 net/bluetooth/cmtp/core.c                          |    5 -
 net/bluetooth/cmtp/sock.c                          |    5 -
 net/bluetooth/hci_conn.c                           |    5 -
 net/bluetooth/hci_core.c                           |   11 +-
 net/bluetooth/hci_event.c                          |    5 -
 net/bluetooth/hci_sock.c                           |    5 -
 net/bluetooth/hci_sysfs.c                          |   12 +-
 net/bluetooth/hidp/core.c                          |    5 -
 net/bluetooth/hidp/sock.c                          |    5 -
 net/bluetooth/l2cap.c                              |    5 -
 net/bluetooth/rfcomm/core.c                        |    5 -
 net/bluetooth/rfcomm/sock.c                        |    9 +-
 net/bluetooth/rfcomm/tty.c                         |   48 +-
 net/bluetooth/sco.c                                |    5 -
 net/bridge/br_device.c                             |   20 +-
 net/bridge/br_if.c                                 |    4 +-
 net/bridge/br_netfilter.c                          |   13 +-
 net/bridge/br_sysfs_br.c                           |    2 +-
 net/bridge/netfilter/ebt_log.c                     |   18 +-
 net/bridge/netfilter/ebtable_broute.c              |   26 +-
 net/bridge/netfilter/ebtable_filter.c              |   41 +-
 net/bridge/netfilter/ebtable_nat.c                 |   38 +-
 net/bridge/netfilter/ebtables.c                    |   52 +-
 net/can/raw.c                                      |   22 +-
 net/core/datagram.c                                |    5 +-
 net/core/dev.c                                     |  458 +-
 net/core/dst.c                                     |    6 +-
 net/core/ethtool.c                                 |   53 +-
 net/core/fib_rules.c                               |    7 +-
 net/core/filter.c                                  |   19 +
 net/core/flow.c                                    |    6 +-
 net/core/gen_estimator.c                           |   97 +-
 net/core/neighbour.c                               |   73 +-
 net/core/net-sysfs.c                               |   15 +-
 net/core/net_namespace.c                           |    2 -
 net/core/netpoll.c                                 |   20 +-
 net/core/pktgen.c                                  |   42 +-
 net/core/rtnetlink.c                               |   15 +-
 net/core/skbuff.c                                  |  277 +-
 net/core/sock.c                                    |   46 +-
 net/core/sysctl_net_core.c                         |   68 +-
 net/dcb/Kconfig                                    |   22 +
 net/dcb/Makefile                                   |    1 +
 net/dcb/dcbnl.c                                    | 1122 +++
 net/dccp/ackvec.c                                  |    9 +-
 net/dccp/ackvec.h                                  |    5 +-
 net/dccp/ccid.c                                    |   62 +-
 net/dccp/ccid.h                                    |   26 +-
 net/dccp/ccids/ccid2.c                             |    6 +-
 net/dccp/dccp.h                                    |   17 +-
 net/dccp/diag.c                                    |   11 +-
 net/dccp/feat.c                                    | 1458 +++-
 net/dccp/feat.h                                    |  130 +-
 net/dccp/input.c                                   |   44 +-
 net/dccp/ipv4.c                                    |   13 +-
 net/dccp/ipv6.c                                    |   15 +-
 net/dccp/minisocks.c                               |   54 +-
 net/dccp/options.c                                 |  229 +-
 net/dccp/output.c                                  |   19 +-
 net/dccp/probe.c                                   |   19 +-
 net/dccp/proto.c                                   |  224 +-
 net/dccp/sysctl.c                                  |   21 -
 net/dccp/timer.c                                   |   12 -
 net/decnet/af_decnet.c                             |   62 +-
 net/decnet/dn_dev.c                                |   22 +-
 net/decnet/dn_neigh.c                              |   18 +-
 net/decnet/dn_nsp_in.c                             |   28 +-
 net/decnet/dn_nsp_out.c                            |   23 +-
 net/decnet/dn_route.c                              |   29 +-
 net/decnet/dn_table.c                              |    2 +-
 net/decnet/sysctl_net_decnet.c                     |   48 +-
 net/dsa/mv88e6060.c                                |    6 +-
 net/dsa/mv88e6123_61_65.c                          |    4 +-
 net/dsa/mv88e6131.c                                |    4 +-
 net/dsa/mv88e6xxx.c                                |    2 +-
 net/dsa/slave.c                                    |    2 +-
 net/dsa/tag_dsa.c                                  |    1 -
 net/dsa/tag_edsa.c                                 |    1 -
 net/dsa/tag_trailer.c                              |    1 -
 net/ethernet/eth.c                                 |   19 +-
 net/ieee80211/Kconfig                              |   73 -
 net/ieee80211/Makefile                             |   12 -
 net/ieee80211/ieee80211_crypt.c                    |  206 -
 net/ipv4/af_inet.c                                 |  116 +-
 net/ipv4/ah4.c                                     |   10 +-
 net/ipv4/arp.c                                     |   36 +-
 net/ipv4/cipso_ipv4.c                              |    1 -
 net/ipv4/devinet.c                                 |   19 +-
 net/ipv4/esp4.c                                    |    8 +-
 net/ipv4/fib_frontend.c                            |   10 +-
 net/ipv4/fib_hash.c                                |   12 +-
 net/ipv4/fib_semantics.c                           |    8 +-
 net/ipv4/fib_trie.c                                |    6 +-
 net/ipv4/icmp.c                                    |   39 +-
 net/ipv4/igmp.c                                    |   95 +-
 net/ipv4/inet_connection_sock.c                    |   31 +-
 net/ipv4/inet_diag.c                               |   31 +-
 net/ipv4/inet_hashtables.c                         |  277 +-
 net/ipv4/inet_lro.c                                |    4 +-
 net/ipv4/inet_timewait_sock.c                      |   48 +-
 net/ipv4/inetpeer.c                                |    2 +-
 net/ipv4/ip_forward.c                              |    2 +-
 net/ipv4/ip_fragment.c                             |   21 +-
 net/ipv4/ip_gre.c                                  |   58 +-
 net/ipv4/ip_input.c                                |   10 +-
 net/ipv4/ip_output.c                               |   24 +-
 net/ipv4/ip_sockglue.c                             |   72 +-
 net/ipv4/ipcomp.c                                  |   10 +-
 net/ipv4/ipconfig.c                                |   40 +-
 net/ipv4/ipip.c                                    |   37 +-
 net/ipv4/ipmr.c                                    |  280 +-
 net/ipv4/netfilter.c                               |    7 +-
 net/ipv4/netfilter/arp_tables.c                    |   16 +-
 net/ipv4/netfilter/arptable_filter.c               |   12 +-
 net/ipv4/netfilter/ip_tables.c                     |   12 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    9 +-
 net/ipv4/netfilter/ipt_LOG.c                       |    7 +-
 net/ipv4/netfilter/ipt_addrtype.c                  |   16 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   27 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |    4 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   58 +-
 net/ipv4/netfilter/nf_nat_irc.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   27 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   18 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    9 +-
 net/ipv4/proc.c                                    |    8 +-
 net/ipv4/raw.c                                     |   10 +-
 net/ipv4/route.c                                   |  227 +-
 net/ipv4/sysctl_net_ipv4.c                         |  188 +-
 net/ipv4/tcp.c                                     |  130 +-
 net/ipv4/tcp_cubic.c                               |  120 +-
 net/ipv4/tcp_diag.c                                |    2 +-
 net/ipv4/tcp_input.c                               |  511 +-
 net/ipv4/tcp_ipv4.c                                |  137 +-
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv4/tcp_output.c                              |  219 +-
 net/ipv4/tcp_probe.c                               |    7 +-
 net/ipv4/tcp_timer.c                               |   14 +-
 net/ipv4/tcp_yeah.c                                |    4 +-
 net/ipv4/udp.c                                     |  271 +-
 net/ipv4/udp_impl.h                                |    4 +-
 net/ipv4/udplite.c                                 |   14 +-
 net/ipv4/xfrm4_input.c                             |    4 +-
 net/ipv4/xfrm4_policy.c                            |   15 +-
 net/ipv4/xfrm4_state.c                             |    2 -
 net/ipv6/addrconf.c                                |   80 +-
 net/ipv6/addrlabel.c                               |   34 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/ah6.c                                     |    9 +-
 net/ipv6/anycast.c                                 |    6 +-
 net/ipv6/datagram.c                                |    3 +-
 net/ipv6/esp6.c                                    |    7 +-
 net/ipv6/exthdrs.c                                 |    2 +-
 net/ipv6/icmp.c                                    |   21 +-
 net/ipv6/inet6_connection_sock.c                   |    2 +-
 net/ipv6/inet6_hashtables.c                        |  182 +-
 net/ipv6/ip6_flowlabel.c                           |    6 +-
 net/ipv6/ip6_output.c                              |    5 +-
 net/ipv6/ip6_tunnel.c                              |   37 +-
 net/ipv6/ip6mr.c                                   |  490 +-
 net/ipv6/ipcomp6.c                                 |   10 +-
 net/ipv6/ipv6_sockglue.c                           |   34 +-
 net/ipv6/mcast.c                                   |   41 +-
 net/ipv6/mip6.c                                    |    3 +-
 net/ipv6/ndisc.c                                   |  105 +-
 net/ipv6/netfilter.c                               |    7 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |    7 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/ipv6/netfilter/ip6table_filter.c               |   17 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    5 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    6 +-
 net/ipv6/raw.c                                     |    3 +-
 net/ipv6/reassembly.c                              |   12 +-
 net/ipv6/route.c                                   |   47 +-
 net/ipv6/sit.c                                     |   35 +-
 net/ipv6/syncookies.c                              |    2 +-
 net/ipv6/sysctl_net_ipv6.c                         |    4 +-
 net/ipv6/tcp_ipv6.c                                |   28 +-
 net/ipv6/udp.c                                     |  151 +-
 net/ipv6/udp_impl.h                                |    4 +-
 net/ipv6/udplite.c                                 |    9 +-
 net/ipv6/xfrm6_input.c                             |    9 +-
 net/ipv6/xfrm6_policy.c                            |   22 +-
 net/ipv6/xfrm6_state.c                             |    2 -
 net/ipv6/xfrm6_tunnel.c                            |   33 +-
 net/ipx/sysctl_net_ipx.c                           |    2 +-
 net/irda/irlan/irlan_client.c                      |    4 +-
 net/irda/irlan/irlan_common.c                      |    2 +-
 net/irda/irlap_frame.c                             |   17 +-
 net/irda/irsysctl.c                                |   50 +-
 net/irda/irttp.c                                   |   14 +-
 net/irda/timer.c                                   |    2 +-
 net/key/af_key.c                                   |  217 +-
 net/llc/af_llc.c                                   |    1 -
 net/llc/llc_proc.c                                 |    3 +-
 net/llc/sysctl_net_llc.c                           |   20 +-
 net/mac80211/Kconfig                               |    8 +-
 net/mac80211/Makefile                              |    2 +
 net/mac80211/cfg.c                                 |  194 +-
 net/mac80211/debugfs.c                             |   12 +-
 net/mac80211/debugfs_key.c                         |    4 +-
 net/mac80211/debugfs_netdev.c                      |  117 +-
 net/mac80211/debugfs_sta.c                         |   84 +-
 net/mac80211/event.c                               |    5 +-
 net/mac80211/ht.c                                  |  265 +-
 net/mac80211/ieee80211_i.h                         |   90 +-
 net/mac80211/iface.c                               |   54 +-
 net/mac80211/key.c                                 |   10 +-
 net/mac80211/main.c                                |  284 +-
 net/mac80211/mesh.c                                |    4 +-
 net/mac80211/mesh.h                                |    5 +-
 net/mac80211/mesh_hwmp.c                           |    7 +-
 net/mac80211/mesh_plink.c                          |   49 +-
 net/mac80211/mlme.c                                |  606 +-
 net/mac80211/rate.c                                |   52 +-
 net/mac80211/rate.h                                |   11 +-
 net/mac80211/rc80211_minstrel.c                    |  109 +-
 net/mac80211/rc80211_minstrel.h                    |    2 +
 net/mac80211/rc80211_pid.h                         |    3 +-
 net/mac80211/rc80211_pid_algo.c                    |   38 +-
 net/mac80211/rc80211_pid_debugfs.c                 |    5 +-
 net/mac80211/rx.c                                  |  174 +-
 net/mac80211/scan.c                                |   24 +-
 net/mac80211/sta_info.c                            |   37 +-
 net/mac80211/sta_info.h                            |   45 +-
 net/mac80211/tkip.c                                |   10 +-
 net/mac80211/tx.c                                  |  462 +-
 net/mac80211/util.c                                |  107 +-
 net/mac80211/wep.c                                 |   33 +-
 net/mac80211/wep.h                                 |    2 +-
 net/mac80211/wext.c                                |  257 +-
 net/mac80211/wme.c                                 |   32 +-
 net/mac80211/wpa.c                                 |   32 +-
 net/netfilter/Kconfig                              |    5 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   20 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   20 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   82 +-
 net/netfilter/ipvs/ip_vs_dh.c                      |   34 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   13 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   69 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   96 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |    3 -
 net/netfilter/ipvs/ip_vs_nq.c                      |    3 -
 net/netfilter/ipvs/ip_vs_proto.c                   |   38 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c            |   10 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |    8 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |    8 +-
 net/netfilter/ipvs/ip_vs_rr.c                      |    3 -
 net/netfilter/ipvs/ip_vs_sed.c                     |    3 -
 net/netfilter/ipvs/ip_vs_sh.c                      |   34 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    4 +-
 net/netfilter/ipvs/ip_vs_wlc.c                     |    3 -
 net/netfilter/ipvs/ip_vs_wrr.c                     |    3 -
 net/netfilter/ipvs/ip_vs_xmit.c                    |   34 +-
 net/netfilter/nf_conntrack_acct.c                  |    2 +-
 net/netfilter/nf_conntrack_amanda.c                |    1 +
 net/netfilter/nf_conntrack_core.c                  |   61 +-
 net/netfilter/nf_conntrack_ecache.c                |   14 +-
 net/netfilter/nf_conntrack_expect.c                |   43 +-
 net/netfilter/nf_conntrack_ftp.c                   |   24 +-
 net/netfilter/nf_conntrack_h323_main.c             |   13 +-
 net/netfilter/nf_conntrack_helper.c                |   32 +-
 net/netfilter/nf_conntrack_irc.c                   |   14 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |    1 +
 net/netfilter/nf_conntrack_netlink.c               |  201 +-
 net/netfilter/nf_conntrack_pptp.c                  |    1 +
 net/netfilter/nf_conntrack_proto_generic.c         |    4 +-
 net/netfilter/nf_conntrack_proto_gre.c             |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   30 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   50 +-
 net/netfilter/nf_conntrack_proto_udp.c             |    8 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |    4 +-
 net/netfilter/nf_conntrack_sane.c                  |    1 +
 net/netfilter/nf_conntrack_sip.c                   |    1 +
 net/netfilter/nf_conntrack_standalone.c            |   16 +-
 net/netfilter/nf_conntrack_tftp.c                  |    1 +
 net/netfilter/nfnetlink_log.c                      |    4 +-
 net/netfilter/xt_NFLOG.c                           |    5 +-
 net/netfilter/xt_dccp.c                            |   16 +-
 net/netfilter/xt_hashlimit.c                       |   14 +-
 net/netfilter/xt_iprange.c                         |   36 +-
 net/netfilter/xt_recent.c                          |   32 +-
 net/netlabel/netlabel_addrlist.c                   |    4 +-
 net/netlabel/netlabel_mgmt.c                       |    1 -
 net/netlink/af_netlink.c                           |    7 +
 net/netlink/attr.c                                 |    8 +-
 net/netrom/sysctl_net_netrom.c                     |   48 +-
 net/packet/af_packet.c                             |    2 +
 net/phonet/af_phonet.c                             |    8 +-
 net/phonet/pep-gprs.c                              |  218 +-
 net/phonet/pep.c                                   |   38 +-
 net/phonet/pn_dev.c                                |    6 +-
 net/phonet/socket.c                                |   13 +-
 net/phonet/sysctl.c                                |    4 +-
 net/rfkill/rfkill-input.c                          |  337 +-
 net/rfkill/rfkill-input.h                          |    3 +
 net/rfkill/rfkill.c                                |  183 +-
 net/rose/sysctl_net_rose.c                         |   40 +-
 net/rxrpc/af_rxrpc.c                               |    4 +-
 net/rxrpc/ar-connection.c                          |    2 +-
 net/rxrpc/ar-connevent.c                           |    2 +-
 net/rxrpc/ar-error.c                               |    3 +-
 net/rxrpc/ar-local.c                               |   16 +-
 net/rxrpc/ar-peer.c                                |    8 +-
 net/rxrpc/ar-proc.c                                |   16 +-
 net/rxrpc/ar-security.c                            |    2 +-
 net/rxrpc/ar-transport.c                           |   12 +-
 net/rxrpc/rxkad.c                                  |    2 +-
 net/sched/Kconfig                                  |   22 +
 net/sched/Makefile                                 |    2 +
 net/sched/act_api.c                                |   18 +-
 net/sched/act_gact.c                               |    4 +-
 net/sched/act_ipt.c                                |    4 +-
 net/sched/act_mirred.c                             |    4 +-
 net/sched/act_nat.c                                |    4 +-
 net/sched/act_pedit.c                              |    4 +-
 net/sched/act_police.c                             |   33 +-
 net/sched/act_simple.c                             |    4 +-
 net/sched/act_skbedit.c                            |    4 +-
 net/sched/cls_api.c                                |    3 +-
 net/sched/cls_basic.c                              |    2 +-
 net/sched/cls_cgroup.c                             |  288 +
 net/sched/cls_fw.c                                 |    2 +-
 net/sched/cls_route.c                              |    2 +-
 net/sched/cls_tcindex.c                            |    6 -
 net/sched/cls_u32.c                                |   11 +-
 net/sched/ematch.c                                 |   18 +-
 net/sched/sch_api.c                                |   50 +-
 net/sched/sch_atm.c                                |   36 +-
 net/sched/sch_blackhole.c                          |    1 +
 net/sched/sch_cbq.c                                |   76 +-
 net/sched/sch_drr.c                                |  519 ++
 net/sched/sch_dsmark.c                             |   22 +-
 net/sched/sch_fifo.c                               |    4 +-
 net/sched/sch_generic.c                            |   40 +-
 net/sched/sch_gred.c                               |   22 +-
 net/sched/sch_hfsc.c                               |   64 +-
 net/sched/sch_htb.c                                |  171 +-
 net/sched/sch_multiq.c                             |   82 +-
 net/sched/sch_netem.c                              |  160 +-
 net/sched/sch_prio.c                               |   50 +-
 net/sched/sch_red.c                                |   33 +-
 net/sched/sch_sfq.c                                |   71 +-
 net/sched/sch_tbf.c                                |   44 +-
 net/sched/sch_teql.c                               |   19 +-
 net/sctp/ipv6.c                                    |   35 +-
 net/sctp/protocol.c                                |   29 +-
 net/sctp/sm_statefuns.c                            |   24 +-
 net/sctp/socket.c                                  |  206 +-
 net/sctp/sysctl.c                                  |   82 +-
 net/socket.c                                       |    1 -
 net/sunrpc/clnt.c                                  |    8 +-
 net/sunrpc/rpcb_clnt.c                             |   17 +-
 net/sunrpc/svcauth_unix.c                          |   24 +-
 net/sunrpc/svcsock.c                               |    6 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |    4 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   16 +-
 net/sunrpc/xprtrdma/transport.c                    |   14 +-
 net/sunrpc/xprtrdma/verbs.c                        |   16 +-
 net/sunrpc/xprtsock.c                              |   41 +-
 net/tipc/eth_media.c                               |    3 +-
 net/tipc/name_table.c                              |    2 +-
 net/unix/af_unix.c                                 |  200 +-
 net/unix/garbage.c                                 |   12 +-
 net/unix/sysctl_net_unix.c                         |    3 +-
 net/wanrouter/wanmain.c                            |   36 +-
 net/wireless/Kconfig                               |   30 +
 net/wireless/Makefile                              |    7 +
 net/wireless/core.c                                |   14 +-
 net/wireless/core.h                                |   13 +
 net/wireless/lib80211.c                            |  284 +
 .../lib80211_crypt_ccmp.c}                         |  129 +-
 .../lib80211_crypt_tkip.c}                         |  181 +-
 .../lib80211_crypt_wep.c}                          |   79 +-
 net/wireless/nl80211.c                             |  417 +-
 net/wireless/reg.c                                 | 1005 ++-
 net/wireless/reg.h                                 |   33 +-
 net/wireless/sysfs.c                               |   25 +-
 net/wireless/util.c                                |   19 +
 net/wireless/wext-compat.c                         |  139 +
 net/wireless/wext.c                                |    2 +-
 net/x25/sysctl_net_x25.c                           |   22 +-
 net/xfrm/Makefile                                  |    4 +-
 net/xfrm/xfrm_input.c                              |   25 +-
 net/xfrm/xfrm_output.c                             |   18 +-
 net/xfrm/xfrm_policy.c                             |  511 +-
 net/xfrm/xfrm_proc.c                               |   26 +-
 net/xfrm/xfrm_state.c                              |  407 +-
 net/xfrm/xfrm_sysctl.c                             |   85 +
 net/xfrm/xfrm_user.c                               |  249 +-
 security/selinux/avc.c                             |    4 +-
 security/selinux/hooks.c                           |    4 +-
 1395 files changed, 73267 insertions(+), 48032 deletions(-)
 delete mode 100644 Documentation/DocBook/wanbook.tmpl
 create mode 100644 Documentation/RCU/rculist_nulls.txt
 create mode 100644 drivers/atm/solos-pci.c
 delete mode 100644 drivers/bluetooth/hci_usb.c
 delete mode 100644 drivers/bluetooth/hci_usb.h
 create mode 100644 drivers/net/arm/ks8695net.c
 create mode 100644 drivers/net/arm/ks8695net.h
 create mode 100644 drivers/net/bonding/bond_ipv6.c
 delete mode 100644 drivers/net/eepro100.c
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb.c
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb.h
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb_82598.c
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb_82598.h
 create mode 100644 drivers/net/ixgbe/ixgbe_dcb_nl.c
 create mode 100644 drivers/net/phy/et1011c.c
 create mode 100644 drivers/net/phy/mdio-gpio.c
 delete mode 100644 drivers/net/phy/mdio-ofgpio.c
 create mode 100644 drivers/net/phy/national.c
 create mode 100644 drivers/net/phy/ste10Xp.c
 create mode 100644 drivers/net/sfc/falcon_gmac.c
 create mode 100644 drivers/net/sfc/mtd.c
 create mode 100644 drivers/net/smsc911x.c
 create mode 100644 drivers/net/smsc911x.h
 create mode 100644 drivers/net/smsc9420.c
 create mode 100644 drivers/net/smsc9420.h
 rename drivers/net/wan/{hd6457x.c => hd64570.c} (78%)
 create mode 100644 drivers/net/wan/hd64572.c
 create mode 100644 drivers/net/wan/ixp4xx_hss.c
 delete mode 100644 drivers/net/wan/syncppp.c
 create mode 100644 drivers/net/wireless/ath9k/ani.c
 create mode 100644 drivers/net/wireless/ath9k/calib.c
 delete mode 100644 drivers/net/wireless/ath9k/core.c
 create mode 100644 drivers/net/wireless/ath9k/debug.c
 create mode 100644 drivers/net/wireless/ath9k/eeprom.c
 create mode 100644 drivers/net/wireless/ath9k/mac.c
 create mode 100644 drivers/net/wireless/ipw2x00/Kconfig
 create mode 100644 drivers/net/wireless/ipw2x00/Makefile
 rename drivers/net/wireless/{ => ipw2x00}/ipw2100.c (99%)
 rename drivers/net/wireless/{ => ipw2x00}/ipw2100.h (100%)
 rename drivers/net/wireless/{ => ipw2x00}/ipw2200.c (97%)
 rename drivers/net/wireless/{ => ipw2x00}/ipw2200.h (99%)
 rename net/ieee80211/ieee80211_geo.c => drivers/net/wireless/ipw2x00/libipw_geo.c (100%)
 rename net/ieee80211/ieee80211_module.c => drivers/net/wireless/ipw2x00/libipw_module.c (88%)
 rename net/ieee80211/ieee80211_rx.c => drivers/net/wireless/ipw2x00/libipw_rx.c (94%)
 rename net/ieee80211/ieee80211_tx.c => drivers/net/wireless/ipw2x00/libipw_tx.c (98%)
 rename net/ieee80211/ieee80211_wx.c => drivers/net/wireless/ipw2x00/libipw_wx.c (91%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.c
 create mode 100644 drivers/net/wireless/orinoco/Makefile
 rename drivers/net/wireless/{ => orinoco}/airport.c (99%)
 rename drivers/net/wireless/{ => orinoco}/hermes.c (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes.h (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes_dld.c (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes_dld.h (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes_rid.h (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco.c (96%)
 rename drivers/net/wireless/{ => orinoco}/orinoco.h (96%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_cs.c (98%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_nortel.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_pci.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_pci.h (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_plx.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_tmd.c (100%)
 rename drivers/net/wireless/{ => orinoco}/spectrum_cs.c (95%)
 create mode 100644 drivers/net/wireless/rtl818x/Makefile
 rename drivers/net/wireless/{ => rtl818x}/rtl8180.h (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_dev.c (96%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_grf5101.c (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_grf5101.h (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_max2820.c (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_max2820.h (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_rtl8225.c (98%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_rtl8225.h (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_sa2400.c (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8180_sa2400.h (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8187.h (97%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8187_dev.c (79%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8187_rtl8225.c (69%)
 rename drivers/net/wireless/{ => rtl818x}/rtl8187_rtl8225.h (100%)
 rename drivers/net/wireless/{ => rtl818x}/rtl818x.h (98%)
 create mode 100644 drivers/usb/gadget/f_phonet.c
 create mode 100644 drivers/usb/gadget/u_phonet.h
 create mode 100644 firmware/cxgb3/t3b_psram-1.1.0.bin.ihex
 create mode 100644 firmware/cxgb3/t3c_psram-1.1.0.bin.ihex
 create mode 100644 firmware/cxgb3/t3fw-7.0.0.bin.ihex
 create mode 100644 include/linux/dcbnl.h
 create mode 100644 include/linux/list_nulls.h
 create mode 100644 include/linux/mdio-gpio.h
 create mode 100644 include/linux/rculist_nulls.h
 create mode 100644 include/linux/smsc911x.h
 create mode 100644 include/net/dcbnl.h
 rename include/net/{ieee80211_crypt.h => lib80211.h} (58%)
 create mode 100644 include/net/netfilter/nfnetlink_log.h
 create mode 100644 include/net/netns/xfrm.h
 delete mode 100644 include/net/syncppp.h
 create mode 100644 net/dcb/Kconfig
 create mode 100644 net/dcb/Makefile
 create mode 100644 net/dcb/dcbnl.c
 delete mode 100644 net/ieee80211/Kconfig
 delete mode 100644 net/ieee80211/Makefile
 delete mode 100644 net/ieee80211/ieee80211_crypt.c
 create mode 100644 net/sched/cls_cgroup.c
 create mode 100644 net/sched/sch_drr.c
 create mode 100644 net/wireless/lib80211.c
 rename net/{ieee80211/ieee80211_crypt_ccmp.c => wireless/lib80211_crypt_ccmp.c} (74%)
 rename net/{ieee80211/ieee80211_crypt_tkip.c => wireless/lib80211_crypt_tkip.c} (79%)
 rename net/{ieee80211/ieee80211_crypt_wep.c => wireless/lib80211_crypt_wep.c} (74%)
 create mode 100644 net/wireless/wext-compat.c
 create mode 100644 net/xfrm/xfrm_sysctl.c
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
