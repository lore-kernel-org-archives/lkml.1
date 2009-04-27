Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZD0FOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZD0FOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 01:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZD0FN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 01:13:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45066 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZD0FNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 01:13:52 -0400
Message-ID: <49F53F07.8020203@linux.vnet.ibm.com>
Date: Sun, 26 Apr 2009 22:13:43 -0700
From: jvrao <jvrao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Linux Driver <Linux-Driver@qlogic.com>
Subject: Re: Interrupts are being dropped under heavy IO on -rt .
References: <49DF71CF.7070509@linux.vnet.ibm.com> <20090415194802.GD1382@plap4-2.local> <49F0DFD7.5040107@linux.vnet.ibm.com>
In-Reply-To: <49F0DFD7.5040107@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------050107010703090202060009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050107010703090202060009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Andrew, I ran the IO intensive tests with MSI interrupts enabled.


[root@elm3c29 ~]# grep MSI /proc/interrupts 
2300:          0          2          0         36   PCI-MSI-edge      eth
2301:          0          0          0         27   PCI-MSI-edge      eth1
2302:         38      13965      15586   15402995   PCI-MSI-edge      qla2xxx
2303:         24      12116      13071   14253323   PCI-MSI-edge      qla2xxx


As per your request I enabled ql2xextended_error_logging, and also set the dev.scsi.logging_level to 4100 for additional info.

Please find the messages file attached.

Thanks,
JV

jvrao wrote:
> Andrew Vasquez wrote:
>> On Fri, 10 Apr 2009, jvrao wrote:
>>
>>> Qlogic driver uses MSI-EDGE interrupts by default.
>>>  
>>> On -rt kernel under heavy IO load we observed that the driver missed 
>>> interrupts occasionally.
>>>
>>> Missing interrupts caused spurious mailbox timeouts and path failovers.
>>>
>>> Suspecting MSI interrupts, we disabled MSI and forcing the driver to use 
>>> APIC interrupts (Patch attached).
>>>
>>> With this change, our IO tests ran for extended period of time without 
>>> any issues.
>>>
>>> It would be interesting to see if the MSI infrastructure itself has 
>>> issues on realtime, or it is the combination of qla2xxx/MSI.
>>>
>>> Right now we don't have any setup to test out MSI with other adapters. 
>>> Hence, wondering if anyone faced similar issues.
>> Could you perhaps provide some details on hardware used within your
>> testing -- HBA type, storage, etc?  Also, can you share any logs of
>> the failures with extended-error-logging enabled
>> (ql2xextended_error_logging)?
> 
> Hi, the following link provides more information on the logs and our analysis.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=466903
> 
> [root@elm3c29 R2-SR1]# lspci | grep -i qlogic
> 03:05.0 Fibre Channel: QLogic Corp. ISP2422-based 4Gb Fibre Channel to PCI-X HBA (rev 02)
> 03:05.1 Fibre Channel: QLogic Corp. ISP2422-based 4Gb Fibre Channel to PCI-X HBA (rev 02)
> 
> 
> Storage is DS4700 (Product ID: 1814)
> 
> If you need more information, please let me know, I can generate more information/logs.
> I will also find time to reproduce this with ql2xextended_error_logging enabled.
> 
> Thanks,
> JV
> 
>> Regards,
>> Andrew Vasquez
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------050107010703090202060009
Content-Type: text/plain;
 name="messages.withMSI"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages.withMSI"

Apr 26 04:03:13 elm3c29 syslogd 1.4.1: restart.
Apr 26 04:04:14 elm3c29 kernel: sd 0:0:1:2: [sdc] Done: SUCCESS
Apr 26 04:04:14 elm3c29 kernel: sd 0:0:1:2: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 04:04:14 elm3c29 kernel: sd 0:0:1:2: [sdc] CDB: Read(10): 28 00 00 00 04 2a 00 00 02 00
Apr 26 04:04:14 elm3c29 kernel: sd 0:0:1:2: [sdc] Sense Key : Unit Attention [current] 
Apr 26 04:04:14 elm3c29 kernel: sd 0:0:1:2: [sdc] Add. Sense: Device internal reset
Apr 26 04:04:15 elm3c29 kernel: sd 1:0:0:3: [sdm] Done: SUCCESS
Apr 26 04:04:15 elm3c29 kernel: sd 1:0:0:3: [sdm] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 04:04:15 elm3c29 kernel: sd 1:0:0:3: [sdm] CDB: Read(10): 28 00 00 00 04 2a 00 00 02 00
Apr 26 04:04:15 elm3c29 kernel: sd 1:0:0:3: [sdm] Sense Key : Unit Attention [current] 
Apr 26 04:04:15 elm3c29 kernel: sd 1:0:0:3: [sdm] Add. Sense: Device internal reset
Apr 26 04:31:53 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 04:43:57 elm3c29 kernel: sd 1:0:0:6: [sdq] Done: SUCCESS
Apr 26 04:43:57 elm3c29 kernel: sd 1:0:0:6: [sdq] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 04:43:57 elm3c29 kernel: sd 1:0:0:6: [sdq] CDB: Read(10): 28 00 00 00 30 18 00 00 08 00
Apr 26 04:43:57 elm3c29 kernel: sd 1:0:0:6: [sdq] Sense Key : Unit Attention [current] 
Apr 26 04:43:57 elm3c29 kernel: sd 1:0:0:6: [sdq] Add. Sense: Device internal reset
Apr 26 05:31:48 elm3c29 kernel: scsi 1:0:0:31: Done: TIMEOUT
Apr 26 05:31:48 elm3c29 kernel: scsi 1:0:0:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:31:48 elm3c29 kernel: scsi 1:0:0:31: CDB: Read(6): 08 00 02 00 01 00
Apr 26 05:32:15 elm3c29 kernel: sd 1:0:0:1: [sdh] Done: TIMEOUT
Apr 26 05:32:15 elm3c29 kernel: sd 1:0:0:1: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:32:15 elm3c29 kernel: sd 1:0:0:1: [sdh] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Read(10): 28 00 00 d0 ae b7 00 00 08 00
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:8: [sds] Done: TIMEOUT
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:8: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:8: [sds] CDB: Read(10): 28 00 00 1a 4e 70 00 00 68 00
Apr 26 05:33:12 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 05:33:43 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 05:33:43 elm3c29 multipathd: sdh: rdac checker reports path is down 
Apr 26 05:33:45 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:33:45 elm3c29 java: SGIO host_status=0x8
Apr 26 05:33:45 elm3c29 multipathd: checker failed path 8:112 in map mpath1 
Apr 26 05:33:45 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 3b 87 10 00 00 08 00
Apr 26 05:33:45 elm3c29 java: SGIO driver_status=0x8
Apr 26 05:33:45 elm3c29 multipathd: mpath1: remaining active paths: 1 
Apr 26 05:33:45 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 05:33:46 elm3c29 multipathd: dm-5: add map (uevent) 
Apr 26 05:33:46 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:33:46 elm3c29 multipathd: dm-5: devmap already registered 
Apr 26 05:33:46 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Read(10): 28 00 00 9d f8 30 00 00 08 00
Apr 26 05:33:47 elm3c29 kernel: Error handler scsi_eh_1 waking up
Apr 26 05:33:47 elm3c29 kernel: sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 05:33:47 elm3c29 kernel: sd 1:0:0:1: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 05:33:47 elm3c29 kernel: sd 1:0:0:5: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
Apr 26 05:33:47 elm3c29 kernel: sd 1:0:0:8: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 05:33:47 elm3c29 kernel: scsi 1:0:0:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 05:33:48 elm3c29 kernel: Total of 6 commands on 5 devices require eh work
Apr 26 05:33:48 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81004a28be00
Apr 26 05:33:48 elm3c29 kernel: qla2xxx_eh_abort(1): aborting sp ffff81007e4f63c0 from RISC. pid=7374725.
Apr 26 05:33:48 elm3c29 kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 26 05:33:48 elm3c29 kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 26 05:33:48 elm3c29 kernel: qla2xxx 0000:03:05.1: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 05:33:48 elm3c29 kernel: qla2xxx 0000:03:05.1: Performing ISP error recovery - ha= ffff81007e76c610.
Apr 26 05:33:48 elm3c29 kernel: scsi(1): **** Load RISC code ****
Apr 26 05:33:48 elm3c29 kernel: scsi(1): Verifying Checksum of loaded RISC code.
Apr 26 05:33:48 elm3c29 kernel: scsi(1): Checksum OK, start firmware.
Apr 26 05:33:48 elm3c29 kernel: scsi(1): Issue init firmware.
Apr 26 05:33:48 elm3c29 kernel: scsi(1): fcport-0 - port retry count: 29 remaining
Apr 26 05:33:48 elm3c29 multipathd: sdh: rdac checker reports path is down 
Apr 26 05:33:49 elm3c29 kernel: scsi(1): fcport-1 - port retry count: 29 remaining
Apr 26 05:33:49 elm3c29 kernel: scsi(1): Asynchronous P2P MODE received.
Apr 26 05:33:49 elm3c29 kernel: scsi(1): Asynchronous LOOP UP (4 Gbps).
Apr 26 05:33:49 elm3c29 kernel: qla2xxx 0000:03:05.1: LOOP UP detected (4 Gbps).
Apr 26 05:33:49 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE.
Apr 26 05:33:50 elm3c29 kernel: scsi(1): Port database changed ffff 0006 0000.
Apr 26 05:33:50 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 05:33:51 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 05:33:51 elm3c29 kernel: scsi(1): F/W Ready - OK 
Apr 26 05:33:51 elm3c29 kernel: scsi(1): fw_state=3 curr time=1033b38e8.
Apr 26 05:33:52 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 05:33:52 elm3c29 kernel: scsi(1): Configure loop -- dpc flags =0x4080048
Apr 26 05:33:53 elm3c29 kernel: scsi(1): RSCN queue entry[0] = [00/000000].
Apr 26 05:33:53 elm3c29 kernel: scsi(1): device_resync: rscn overflow.
Apr 26 05:33:53 elm3c29 kernel: scsi(1): RFT_ID exiting normally.
Apr 26 05:33:53 elm3c29 kernel: scsi(1): RFF_ID exiting normally.
Apr 26 05:33:53 elm3c29 kernel: scsi(1): RNN_ID exiting normally.
Apr 26 05:33:53 elm3c29 kernel: scsi(1): RSNN_NN exiting normally.
Apr 26 05:33:53 elm3c29 kernel: scsi(1): GID_PT entry - nn 200400a0b8421b14 pn 200500a0b8421b15 portid=010000.
Apr 26 05:33:53 elm3c29 kernel: scsi(1): GID_PT entry - nn 2001001b32252166 pn 2101001b32252166 portid=010400.
Apr 26 05:33:54 elm3c29 kernel: scsi(1): GID_PT entry - nn 2001000e1180034c pn 2002000e1180034c portid=010fe1.
Apr 26 05:33:55 elm3c29 kernel: scsi(1): GPSC failed, rejected request:
Apr 26 05:33:57 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 05:33:58 elm3c29 kernel: --------------------------------------------------------------
Apr 26 05:34:00 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 05:34:01 elm3c29 kernel: scsi(1): GPSC command unsupported, disabling query...
Apr 26 05:34:01 elm3c29 kernel: qla24xx_fabric_logout(1): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 05:34:02 elm3c29 kernel: scsi(1): device wrap (010fe1)
Apr 26 05:34:02 elm3c29 kernel: scsi(1): Trying Fabric Login w/loop id 0x0081 for port 010000.
Apr 26 05:34:02 elm3c29 kernel: scsi(1): Trying Fabric Login w/loop id 0x0082 for port 010fe1.
Apr 26 05:34:03 elm3c29 kernel: scsi(1): LOOP READY
Apr 26 05:34:03 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 05:34:03 elm3c29 kernel: qla2x00_abort_isp(1): exiting.
Apr 26 05:34:03 elm3c29 kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 26 05:34:03 elm3c29 kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 26 05:34:03 elm3c29 kernel: qla2x00_mailbox_command(1): **** FAILED. mbx0=54, mbx1=0, mbx2=7e4f, cmd=54 ****
Apr 26 05:34:03 elm3c29 kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 26 05:34:03 elm3c29 kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 26 05:34:03 elm3c29 kernel: qla24xx_abort_command(1): failed to issue IOCB (100).
Apr 26 05:34:03 elm3c29 kernel: qla2xxx_eh_abort(1): abort_command mbx failed.
Apr 26 05:34:04 elm3c29 kernel: qla2xxx 0000:03:05.1: scsi(1:0:31): Abort command issued -- 0 708785 2002.
Apr 26 05:34:04 elm3c29 kernel: scsi_eh_done scmd: ffff81004a28be00 result: 2
Apr 26 05:34:04 elm3c29 kernel: scsi 1:0:0:31: Done: SUCCESS
Apr 26 05:34:04 elm3c29 kernel: scsi 1:0:0:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:34:04 elm3c29 kernel: scsi 1:0:0:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 05:34:04 elm3c29 kernel: scsi 1:0:0:31: Sense Key : Unit Attention [current] 
Apr 26 05:34:04 elm3c29 kernel: scsi 1:0:0:31: Add. Sense: Device internal reset
Apr 26 05:34:04 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004a28be00, timeleft: 9997
Apr 26 05:34:04 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 05:34:05 elm3c29 kernel: scsi_eh_tur: scmd ffff81004a28be00 rtn 2002
Apr 26 05:34:05 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81004a28b380
Apr 26 05:34:05 elm3c29 kernel: scsi_eh_done scmd: ffff81004a28b380 result: 2
Apr 26 05:34:05 elm3c29 kernel: sd 1:0:0:1: [sdh] Done: SUCCESS
Apr 26 05:34:06 elm3c29 kernel: sd 1:0:0:1: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:34:07 elm3c29 kernel: sd 1:0:0:1: [sdh] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 05:34:07 elm3c29 kernel: sd 1:0:0:1: [sdh] Sense Key : Unit Attention [current] 
Apr 26 05:34:07 elm3c29 kernel: sd 1:0:0:1: [sdh] Add. Sense: Device internal reset
Apr 26 05:34:07 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004a28b380, timeleft: 10000
Apr 26 05:34:07 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 05:34:07 elm3c29 kernel: scsi_eh_tur: scmd ffff81004a28b380 rtn 2002
Apr 26 05:34:07 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff8101255822c0
Apr 26 05:34:07 elm3c29 kernel: scsi_eh_done scmd: ffff8101255822c0 result: 2
Apr 26 05:34:07 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: SUCCESS
Apr 26 05:34:10 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:0: [sdg] Sense Key : Unit Attention [current] 
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:0: [sdg] Add. Sense: Device internal reset
Apr 26 05:34:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8101255822c0, timeleft: 10000
Apr 26 05:34:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 05:34:11 elm3c29 kernel: scsi_eh_tur: scmd ffff8101255822c0 rtn 2002
Apr 26 05:34:11 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810111477400
Apr 26 05:34:11 elm3c29 kernel: scsi_eh_done scmd: ffff810111477400 result: 2
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:8: [sds] Done: SUCCESS
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:8: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:8: [sds] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 05:34:11 elm3c29 kernel: sd 1:0:0:8: [sds] Sense Key : Unit Attention [current] 
Apr 26 05:34:12 elm3c29 kernel: sd 1:0:0:8: [sds] Add. Sense: Device internal reset
Apr 26 05:34:12 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810111477400, timeleft: 10000
Apr 26 05:34:12 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_tur: scmd ffff810111477400 rtn 2002
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81006f0c2d40
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_done scmd: ffff81006f0c2d40 result: 2
Apr 26 05:34:12 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: SUCCESS
Apr 26 05:34:12 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 05:34:12 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 05:34:12 elm3c29 kernel: sd 1:0:0:5: [sdp] Sense Key : Unit Attention [current] 
Apr 26 05:34:12 elm3c29 kernel: sd 1:0:0:5: [sdp] Add. Sense: Device internal reset
Apr 26 05:34:12 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81006f0c2d40, timeleft: 10000
Apr 26 05:34:12 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_tur: scmd ffff81006f0c2d40 rtn 2002
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81014d9dc280
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_done scmd: ffff81014d9dc280 result: 0
Apr 26 05:34:12 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014d9dc280, timeleft: 10000
Apr 26 05:34:12 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_tur: scmd ffff81014d9dc280 rtn 2002
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81004a28be00
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81004a28b380
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff8101255822c0
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810111477400
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81006f0c2d40
Apr 26 05:34:12 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81014d9dc280
Apr 26 05:34:12 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 05:34:12 elm3c29 kernel: Error handler scsi_eh_1 sleeping
Apr 26 05:34:12 elm3c29 kernel: device-mapper: multipath: Failing path 8:112.
Apr 26 05:34:12 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 06:30:48 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 07:15:36 elm3c29 kernel: scsi 0:0:1:31: Done: TIMEOUT
Apr 26 07:15:36 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:15:36 elm3c29 kernel: scsi 0:0:1:31: CDB: Read(6): 08 00 02 af 01 00
Apr 26 07:16:29 elm3c29 kernel: sd 0:0:1:0: [sda] Done: TIMEOUT
Apr 26 07:16:29 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:16:29 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: TIMEOUT
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Read(10): 28 00 00 c3 99 e0 00 00 08 00
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 91 b8 00 00 08 00
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 91 f8 00 00 08 00
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 92 28 00 00 08 00
Apr 26 07:17:16 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:17 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:19 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 92 00 00 00 28 00
Apr 26 07:17:20 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:20 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 91 d8 00 00 08 00
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 91 f0 00 00 08 00
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 92 30 00 00 48 00
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 92 80 00 01 98 00
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 94 20 00 01 98 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 95 c0 00 00 08 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 95 c8 00 01 98 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 97 68 00 00 10 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 97 78 00 00 08 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 97 80 00 01 88 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 99 10 00 01 a0 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 9a b8 00 01 a0 00
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 86 9c 60 00 00 08 00
Apr 26 07:17:22 elm3c29 kernel: Error handler scsi_eh_0 waking up
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 17
Apr 26 07:17:22 elm3c29 kernel: sd 0:0:1:7: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 07:17:22 elm3c29 kernel: scsi 0:0:1:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 07:17:22 elm3c29 kernel: Total of 20 commands on 4 devices require eh work
Apr 26 07:17:22 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100403d3440
Apr 26 07:17:22 elm3c29 kernel: qla2xxx_eh_abort(0): aborting sp ffff810037bf1840 from RISC. pid=9558755.
Apr 26 07:17:46 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 07:17:46 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 07:17:46 elm3c29 kernel: qla2xxx 0000:03:05.0: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 07:17:46 elm3c29 kernel: qla2xxx 0000:03:05.0: Performing ISP error recovery - ha= ffff81007ea44610.
Apr 26 07:17:46 elm3c29 kernel: scsi(0): **** Load RISC code ****
Apr 26 07:17:46 elm3c29 kernel: scsi(0): Verifying Checksum of loaded RISC code.
Apr 26 07:17:46 elm3c29 kernel: scsi(0): Checksum OK, start firmware.
Apr 26 07:17:46 elm3c29 kernel: scsi(0): Issue init firmware.
Apr 26 07:17:46 elm3c29 kernel: scsi(0): Asynchronous P2P MODE received.
Apr 26 07:17:46 elm3c29 kernel: scsi(0): Asynchronous LOOP UP (4 Gbps).
Apr 26 07:17:46 elm3c29 kernel: qla2xxx 0000:03:05.0: LOOP UP detected (4 Gbps).
Apr 26 07:17:46 elm3c29 kernel: scsi(0): F/W Ready - OK 
Apr 26 07:17:46 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE.
Apr 26 07:17:47 elm3c29 multipathd: 8:112: reinstated 
Apr 26 07:17:47 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 07:17:52 elm3c29 kernel: scsi(0): Port database changed ffff 0006 0000.
Apr 26 07:17:52 elm3c29 multipathd: mpath1: remaining active paths: 2 
Apr 26 07:17:56 elm3c29 java: SGIO host_status=0x8
Apr 26 07:17:59 elm3c29 kernel: scsi(0): fw_state=3 curr time=1039a7d47.
Apr 26 07:18:01 elm3c29 multipathd: dm-5: add map (uevent) 
Apr 26 07:18:03 elm3c29 java: SGIO driver_status=0x8
Apr 26 07:18:04 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 07:18:05 elm3c29 multipathd: dm-5: devmap already registered 
Apr 26 07:18:06 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 07:18:07 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 07:18:07 elm3c29 kernel: scsi(0): Configure loop -- dpc flags =0x4080048
Apr 26 07:18:07 elm3c29 multipathd: checker failed path 8:0 in map mpath0 
Apr 26 07:18:07 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 07:18:07 elm3c29 multipathd: mpath0: remaining active paths: 1 
Apr 26 07:18:07 elm3c29 kernel: scsi(0): RSCN queue entry[0] = [00/000000].
Apr 26 07:18:08 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): device_resync: rscn overflow.
Apr 26 07:18:08 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): RFT_ID exiting normally.
Apr 26 07:18:08 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): fcport-0 - port retry count: 29 remaining
Apr 26 07:18:08 elm3c29 multipathd: 8:0: reinstated 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): fcport-1 - port retry count: 29 remaining
Apr 26 07:18:08 elm3c29 multipathd: mpath0: remaining active paths: 2 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): RFF_ID exiting normally.
Apr 26 07:18:08 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): RNN_ID exiting normally.
Apr 26 07:18:08 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 07:18:08 elm3c29 kernel: scsi(0): RSNN_NN exiting normally.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): GID_PT entry - nn 2000001b32052166 pn 2100001b32052166 portid=010400.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): GID_PT entry - nn 2001000e1180034c pn 2001000e1180034c portid=011226.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): GID_PT entry - nn 200400a0b8421b14 pn 200400a0b8421b15 portid=011300.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): GPSC failed, rejected request:
Apr 26 07:18:08 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 07:18:08 elm3c29 kernel: --------------------------------------------------------------
Apr 26 07:18:08 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 07:18:08 elm3c29 kernel: scsi(0): GPSC command unsupported, disabling query...
Apr 26 07:18:08 elm3c29 kernel: qla24xx_fabric_logout(0): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): device wrap (011300)
Apr 26 07:18:08 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 011226.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0082 for port 011300.
Apr 26 07:18:08 elm3c29 kernel: scsi(0): LOOP READY
Apr 26 07:18:08 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 07:18:08 elm3c29 kernel: qla2x00_abort_isp(0): exiting.
Apr 26 07:18:08 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 07:18:08 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 07:18:08 elm3c29 kernel: qla2x00_mailbox_command(0): **** FAILED. mbx0=54, mbx1=0, mbx2=37bf, cmd=54 ****
Apr 26 07:18:08 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 07:18:08 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 07:18:08 elm3c29 kernel: qla24xx_abort_command(0): failed to issue IOCB (100).
Apr 26 07:18:08 elm3c29 kernel: qla2xxx_eh_abort(0): abort_command mbx failed.
Apr 26 07:18:08 elm3c29 kernel: qla2xxx 0000:03:05.0: scsi(0:1:31): Abort command issued -- 0 91dae3 2002.
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff8100403d3440 result: 2
Apr 26 07:18:08 elm3c29 kernel: scsi 0:0:1:31: Done: SUCCESS
Apr 26 07:18:08 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:18:08 elm3c29 kernel: scsi 0:0:1:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 07:18:08 elm3c29 kernel: scsi 0:0:1:31: Sense Key : Unit Attention [current] 
Apr 26 07:18:08 elm3c29 kernel: scsi 0:0:1:31: Add. Sense: Device internal reset
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100403d3440, timeleft: 9997
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff8100403d3440 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810097754140
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff810097754140 result: 2
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:0: [sda] Done: SUCCESS
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:0: [sda] Sense Key : Unit Attention [current] 
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:0: [sda] Add. Sense: Device internal reset
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810097754140, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff810097754140 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100ac9662c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff8100ac9662c0 result: 2
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: SUCCESS
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:7: [sdk] Sense Key : Unit Attention [current] 
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:7: [sdk] Add. Sense: Device internal reset
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100ac9662c0, timeleft: 9999
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff8100ac9662c0 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014e51a400
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81014e51a400 result: 2
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:4: [sde] Done: SUCCESS
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:4: [sde] Sense Key : Unit Attention [current] 
Apr 26 07:18:08 elm3c29 kernel: sd 0:0:1:4: [sde] Add. Sense: Device internal reset
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014e51a400, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81014e51a400 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81013c480480
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81013c480480 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81013c480480, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81013c480480 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81007e904a40
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81007e904a40 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81007e904a40, timeleft: 9998
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81007e904a40 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014e56ba00
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81014e56ba00 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014e56ba00, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81014e56ba00 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d9d0600
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d0600 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d0600, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d0600 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8101304e3a00
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff8101304e3a00 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8101304e3a00, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff8101304e3a00 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014b50bdc0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81014b50bdc0 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014b50bdc0, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81014b50bdc0 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81009dc3a6c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81009dc3a6c0 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81009dc3a6c0, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81009dc3a6c0 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014b50b880
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81014b50b880 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014b50b880, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81014b50b880 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81010c76f540
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81010c76f540 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010c76f540, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81010c76f540 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100ac966d40
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff8100ac966d40 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100ac966d40, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff8100ac966d40 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d8ca340
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81011d8ca340 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d8ca340, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d8ca340 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014e51a5c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81014e51a5c0 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014e51a5c0, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81014e51a5c0 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014b50b340
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81014b50b340 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014b50b340, timeleft: 9999
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81014b50b340 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f1e8380
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81011f1e8380 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f1e8380, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f1e8380 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100ac9669c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff8100ac9669c0 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100ac9669c0, timeleft: 10000
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff8100ac9669c0 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d9d00c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d00c0 result: 0
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d00c0, timeleft: 9999
Apr 26 07:18:08 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d00c0 rtn 2002
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100403d3440
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810097754140
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100ac9662c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014e51a400
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81013c480480
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81007e904a40
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014e56ba00
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d9d0600
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8101304e3a00
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014b50bdc0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81009dc3a6c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014b50b880
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81010c76f540
Apr 26 07:18:08 elm3c29 kernel: device-mapper: multipath: Failing path 8:0.
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100ac966d40
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d8ca340
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014e51a5c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014b50b340
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f1e8380
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100ac9669c0
Apr 26 07:18:08 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d9d00c0
Apr 26 07:18:08 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 07:18:08 elm3c29 kernel: Error handler scsi_eh_0 sleeping
Apr 26 07:29:37 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 08:32:19 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 09:33:18 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 10:32:58 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 11:06:41 elm3c29 kernel: scsi 0:0:1:31: Done: TIMEOUT
Apr 26 11:06:41 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:06:41 elm3c29 kernel: scsi 0:0:1:31: CDB: Read(6): 08 00 02 11 01 00
Apr 26 11:07:26 elm3c29 kernel: sd 0:0:1:0: [sda] Done: TIMEOUT
Apr 26 11:07:26 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:07:26 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 11:08:20 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: TIMEOUT
Apr 26 11:08:20 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:20 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Read(10): 28 00 00 2b 38 b8 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1e b8 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1e d8 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1e e0 00 00 20 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1e d0 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 08 00 00 10 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 30 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 38 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 40 00 00 18 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 00 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 18 00 00 18 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 58 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 1f 60 00 00 80 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 22 10 00 01 10 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 25 50 00 01 10 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 28 a8 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 28 b0 00 00 f0 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 2b e0 00 01 00 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 2f 10 00 01 70 00
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 5c 30 88 00 00 08 00
Apr 26 11:08:21 elm3c29 kernel: Error handler scsi_eh_0 waking up
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 19
Apr 26 11:08:21 elm3c29 kernel: sd 0:0:1:7: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 11:08:21 elm3c29 kernel: scsi 0:0:1:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 11:08:21 elm3c29 kernel: Total of 22 commands on 4 devices require eh work
Apr 26 11:08:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810124c784c0
Apr 26 11:08:21 elm3c29 kernel: qla2xxx_eh_abort(0): aborting sp ffff810126d90480 from RISC. pid=11186548.
Apr 26 11:08:51 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 11:08:51 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 11:08:51 elm3c29 kernel: qla2xxx 0000:03:05.0: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 11:08:51 elm3c29 kernel: qla2xxx 0000:03:05.0: Performing ISP error recovery - ha= ffff81007ea44610.
Apr 26 11:08:51 elm3c29 kernel: scsi(0): **** Load RISC code ****
Apr 26 11:08:51 elm3c29 kernel: scsi(0): Verifying Checksum of loaded RISC code.
Apr 26 11:08:51 elm3c29 kernel: scsi(0): Checksum OK, start firmware.
Apr 26 11:08:51 elm3c29 kernel: scsi(0): fcport-0 - port retry count: 29 remaining
Apr 26 11:08:51 elm3c29 kernel: scsi(0): fcport-1 - port retry count: 29 remaining
Apr 26 11:08:51 elm3c29 kernel: scsi(0): Issue init firmware.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Asynchronous P2P MODE received.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Asynchronous LOOP UP (4 Gbps).
Apr 26 11:08:52 elm3c29 kernel: qla2xxx 0000:03:05.0: LOOP UP detected (4 Gbps).
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Port database changed ffff 0006 0000.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): F/W Ready - OK 
Apr 26 11:08:52 elm3c29 kernel: scsi(0): fw_state=3 curr time=1046e1003.
Apr 26 11:08:52 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Configure loop -- dpc flags =0x4080048
Apr 26 11:08:52 elm3c29 kernel: scsi(0): RSCN queue entry[0] = [00/000000].
Apr 26 11:08:52 elm3c29 kernel: scsi(0): device_resync: rscn overflow.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): RFT_ID exiting normally.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): RFF_ID exiting normally.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): RNN_ID exiting normally.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): RSNN_NN exiting normally.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): GID_PT entry - nn 2000001b32052166 pn 2100001b32052166 portid=010400.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): GID_PT entry - nn 2001000e1180034c pn 2001000e1180034c portid=011226.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): GID_PT entry - nn 200400a0b8421b14 pn 200400a0b8421b15 portid=011300.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): GPSC failed, rejected request:
Apr 26 11:08:52 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 11:08:52 elm3c29 kernel: --------------------------------------------------------------
Apr 26 11:08:52 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 11:08:52 elm3c29 kernel: scsi(0): GPSC command unsupported, disabling query...
Apr 26 11:08:52 elm3c29 kernel: qla24xx_fabric_logout(0): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): device wrap (011300)
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 011226.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0082 for port 011300.
Apr 26 11:08:52 elm3c29 kernel: scsi(0): LOOP READY
Apr 26 11:08:52 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 11:08:52 elm3c29 kernel: qla2x00_abort_isp(0): exiting.
Apr 26 11:08:52 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 11:08:52 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 11:08:52 elm3c29 kernel: qla2x00_mailbox_command(0): **** FAILED. mbx0=54, mbx1=0, mbx2=37bf, cmd=54 ****
Apr 26 11:08:52 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 11:08:52 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 11:08:52 elm3c29 kernel: qla24xx_abort_command(0): failed to issue IOCB (100).
Apr 26 11:08:52 elm3c29 kernel: qla2xxx_eh_abort(0): abort_command mbx failed.
Apr 26 11:08:52 elm3c29 kernel: qla2xxx 0000:03:05.0: scsi(0:1:31): Abort command issued -- 0 aab174 2002.
Apr 26 11:08:52 elm3c29 kernel: scsi_eh_done scmd: ffff810124c784c0 result: 2
Apr 26 11:08:52 elm3c29 kernel: scsi 0:0:1:31: Done: SUCCESS
Apr 26 11:08:52 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:52 elm3c29 kernel: scsi 0:0:1:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:08:52 elm3c29 kernel: scsi 0:0:1:31: Sense Key : Unit Attention [current] 
Apr 26 11:08:52 elm3c29 kernel: scsi 0:0:1:31: Add. Sense: Device internal reset
Apr 26 11:08:52 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124c784c0, timeleft: 9997
Apr 26 11:08:52 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 11:08:53 elm3c29 java: SGIO host_status=0x8
Apr 26 11:08:53 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:53 elm3c29 java: SGIO driver_status=0x8
Apr 26 11:08:52 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810124c784c0 rtn 2002
Apr 26 11:08:58 elm3c29 multipathd: checker failed path 8:0 in map mpath0 
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100af57bd00
Apr 26 11:08:58 elm3c29 multipathd: mpath0: remaining active paths: 1 
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff8100af57bd00 result: 2
Apr 26 11:08:58 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:0: [sda] Done: SUCCESS
Apr 26 11:08:58 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:0: [sda] Sense Key : Unit Attention [current] 
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:0: [sda] Add. Sense: Device internal reset
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100af57bd00, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff8100af57bd00 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100ac4d5c00
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff8100ac4d5c00 result: 2
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: SUCCESS
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:7: [sdk] Sense Key : Unit Attention [current] 
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:7: [sdk] Add. Sense: Device internal reset
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100ac4d5c00, timeleft: 9999
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff8100ac4d5c00 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050d829c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d829c0 result: 2
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:4: [sde] Done: SUCCESS
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:4: [sde] Sense Key : Unit Attention [current] 
Apr 26 11:08:58 elm3c29 kernel: sd 0:0:1:4: [sde] Add. Sense: Device internal reset
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d829c0, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d829c0 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050d3e280
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d3e280 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d3e280, timeleft: 9997
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d3e280 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810124c78840
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810124c78840 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124c78840, timeleft: 9999
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810124c78840 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050cb7cc0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050cb7cc0 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050cb7cc0, timeleft: 9998
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050cb7cc0 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050d3e440
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d3e440 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d3e440, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d3e440 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810069f6f4c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810069f6f4c0 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810069f6f4c0, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810069f6f4c0 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050d82640
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d82640 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d82640, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d82640 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81004bdade00
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff81004bdade00 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004bdade00, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81004bdade00 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050cb7240
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050cb7240 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050cb7240, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050cb7240 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810124c78d80
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810124c78d80 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124c78d80, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810124c78d80 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810018cb8cc0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810018cb8cc0 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810018cb8cc0, timeleft: 9999
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810018cb8cc0 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81007e50b780
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff81007e50b780 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81007e50b780, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81007e50b780 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050d3eb40
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d3eb40 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d3eb40, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d3eb40 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81005ac9d1c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff81005ac9d1c0 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005ac9d1c0, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81005ac9d1c0 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81005e959b80
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff81005e959b80 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005e959b80, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81005e959b80 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050d82100
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d82100 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d82100, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d82100 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81003e907d80
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907d80 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907d80, timeleft: 9999
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907d80 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81003e9074c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e9074c0 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e9074c0, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e9074c0 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810069f6f680
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_done scmd: ffff810069f6f680 result: 0
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810069f6f680, timeleft: 10000
Apr 26 11:08:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810069f6f680 rtn 2002
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810124c784c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100af57bd00
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100ac4d5c00
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050d829c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050d3e280
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810124c78840
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050cb7cc0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050d3e440
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810069f6f4c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050d82640
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81004bdade00
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050cb7240
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810124c78d80
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810018cb8cc0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81007e50b780
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050d3eb40
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81005ac9d1c0
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81005e959b80
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050d82100
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81003e907d80
Apr 26 11:08:58 elm3c29 kernel: device-mapper: multipath: Failing path 8:0.
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81003e9074c0
Apr 26 11:08:58 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 11:08:58 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810069f6f680
Apr 26 11:08:58 elm3c29 multipathd: 8:0: reinstated 
Apr 26 11:08:58 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 11:08:58 elm3c29 multipathd: mpath0: remaining active paths: 2 
Apr 26 11:08:58 elm3c29 kernel: Error handler scsi_eh_0 sleeping
Apr 26 11:08:58 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 11:08:58 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 11:33:56 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 11:57:12 elm3c29 kernel: scsi 1:0:0:31: Done: TIMEOUT
Apr 26 11:57:12 elm3c29 kernel: scsi 1:0:0:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:57:12 elm3c29 kernel: scsi 1:0:0:31: CDB: Read(6): 08 00 02 00 01 00
Apr 26 11:57:20 elm3c29 kernel: sd 1:0:0:1: [sdh] Done: TIMEOUT
Apr 26 11:57:20 elm3c29 kernel: sd 1:0:0:1: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:57:20 elm3c29 kernel: sd 1:0:0:1: [sdh] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ed 10 00 00 08 00
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ed 00 00 00 10 00
Apr 26 11:58:09 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:41 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 11:58:41 elm3c29 multipathd: sdh: rdac checker reports path is down 
Apr 26 11:58:41 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:42 elm3c29 java: SGIO host_status=0x8
Apr 26 11:58:44 elm3c29 multipathd: checker failed path 8:112 in map mpath1 
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 eb e0 00 00 08 00
Apr 26 11:58:44 elm3c29 java: SGIO driver_status=0x8
Apr 26 11:58:44 elm3c29 multipathd: mpath1: remaining active paths: 1 
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ec 28 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ec 68 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ec f8 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] CDB: Read(10): 28 00 00 ca 32 f8 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ed 18 00 00 20 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ec a8 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ec c8 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ed 38 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 87 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 97 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 3f 00 00 10 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 57 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ed 40 00 02 38 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ef 80 00 03 40 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 f2 c8 00 03 40 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 f6 10 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 7f 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 f6 18 00 03 38 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 f9 58 00 03 40 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 fc a0 00 03 48 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 72 ff f0 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Read(10): 28 00 00 74 00 00 00 00 08 00
Apr 26 11:58:44 elm3c29 kernel: Error handler scsi_eh_1 waking up
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 5
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:1: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 19
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 11:58:44 elm3c29 kernel: scsi 1:0:0:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 11:58:44 elm3c29 kernel: Total of 27 commands on 5 devices require eh work
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011d9d0600
Apr 26 11:58:44 elm3c29 kernel: qla2xxx_eh_abort(1): aborting sp ffff8100a59ef880 from RISC. pid=11176099.
Apr 26 11:58:44 elm3c29 kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 26 11:58:44 elm3c29 kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 26 11:58:44 elm3c29 kernel: qla2xxx 0000:03:05.1: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 11:58:44 elm3c29 kernel: qla2xxx 0000:03:05.1: Performing ISP error recovery - ha= ffff81007e76c610.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): fcport-0 - port retry count: 29 remaining
Apr 26 11:58:44 elm3c29 kernel: scsi(1): fcport-1 - port retry count: 29 remaining
Apr 26 11:58:44 elm3c29 kernel: scsi(1): **** Load RISC code ****
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Verifying Checksum of loaded RISC code.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Checksum OK, start firmware.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Issue init firmware.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Asynchronous P2P MODE received.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Asynchronous LOOP UP (4 Gbps).
Apr 26 11:58:44 elm3c29 kernel: qla2xxx 0000:03:05.1: LOOP UP detected (4 Gbps).
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Port database changed ffff 0006 0000.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): F/W Ready - OK 
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): fw_state=3 curr time=1049ba9d3.
Apr 26 11:58:44 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Configure loop -- dpc flags =0x4080048
Apr 26 11:58:44 elm3c29 kernel: scsi(1): RSCN queue entry[0] = [00/000000].
Apr 26 11:58:44 elm3c29 kernel: scsi(1): device_resync: rscn overflow.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): RFT_ID exiting normally.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): RFF_ID exiting normally.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): RNN_ID exiting normally.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): RSNN_NN exiting normally.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): GID_PT entry - nn 200400a0b8421b14 pn 200500a0b8421b15 portid=010000.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): GID_PT entry - nn 2001001b32252166 pn 2101001b32252166 portid=010400.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): GID_PT entry - nn 2001000e1180034c pn 2002000e1180034c portid=010fe1.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): GPSC failed, rejected request:
Apr 26 11:58:44 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 11:58:44 elm3c29 kernel: --------------------------------------------------------------
Apr 26 11:58:44 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 11:58:44 elm3c29 kernel: scsi(1): GPSC command unsupported, disabling query...
Apr 26 11:58:44 elm3c29 kernel: scsi(1): fcport-0 - port retry count: 28 remaining
Apr 26 11:58:44 elm3c29 kernel: scsi(1): fcport-1 - port retry count: 28 remaining
Apr 26 11:58:44 elm3c29 kernel: qla24xx_fabric_logout(1): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): device wrap (010fe1)
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Trying Fabric Login w/loop id 0x0081 for port 010000.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): Trying Fabric Login w/loop id 0x0082 for port 010fe1.
Apr 26 11:58:44 elm3c29 kernel: scsi(1): LOOP READY
Apr 26 11:58:44 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 11:58:44 elm3c29 kernel: qla2x00_abort_isp(1): exiting.
Apr 26 11:58:44 elm3c29 kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 26 11:58:44 elm3c29 kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 26 11:58:44 elm3c29 kernel: qla2x00_mailbox_command(1): **** FAILED. mbx0=54, mbx1=0, mbx2=7e4f, cmd=54 ****
Apr 26 11:58:44 elm3c29 kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 26 11:58:44 elm3c29 kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 26 11:58:44 elm3c29 kernel: qla24xx_abort_command(1): failed to issue IOCB (100).
Apr 26 11:58:44 elm3c29 kernel: qla2xxx_eh_abort(1): abort_command mbx failed.
Apr 26 11:58:44 elm3c29 kernel: qla2xxx 0000:03:05.1: scsi(1:0:31): Abort command issued -- 0 aa88a3 2002.
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d0600 result: 2
Apr 26 11:58:44 elm3c29 kernel: scsi 1:0:0:31: Done: SUCCESS
Apr 26 11:58:44 elm3c29 kernel: scsi 1:0:0:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: scsi 1:0:0:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:58:44 elm3c29 kernel: scsi 1:0:0:31: Sense Key : Unit Attention [current] 
Apr 26 11:58:44 elm3c29 kernel: scsi 1:0:0:31: Add. Sense: Device internal reset
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d0600, timeleft: 9998
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d0600 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81012c1f1480
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81012c1f1480 result: 2
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:1: [sdh] Done: SUCCESS
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:1: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:1: [sdh] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:1: [sdh] Sense Key : Unit Attention [current] 
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:1: [sdh] Add. Sense: Device internal reset
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81012c1f1480, timeleft: 9999
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81012c1f1480 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81014d0215c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81014d0215c0 result: 2
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: SUCCESS
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Sense Key : Unit Attention [current] 
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:5: [sdp] Add. Sense: Device internal reset
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014d0215c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81014d0215c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011d9d0d00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d0d00 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d0d00, timeleft: 9999
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d0d00 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810124c784c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810124c784c0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124c784c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810124c784c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81014d021780
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81014d021780 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014d021780, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81014d021780 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810124c34400
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810124c34400 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124c34400, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810124c34400 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810124d5a640
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810124d5a640 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124d5a640, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810124d5a640 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81006fb4c700
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81006fb4c700 result: 2
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] Done: SUCCESS
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] Sense Key : Unit Attention [current] 
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:8: [sds] Add. Sense: Device internal reset
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81006fb4c700, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81006fb4c700 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff8101115157c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff8101115157c0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8101115157c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff8101115157c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810111515d00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810111515d00 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810111515d00, timeleft: 9999
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810111515d00 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810111515b40
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810111515b40 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810111515b40, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810111515b40 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011d8f98c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81011d8f98c0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d8f98c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d8f98c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810111515600
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810111515600 result: 2
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: SUCCESS
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Sense Key : Unit Attention [current] 
Apr 26 11:58:44 elm3c29 kernel: sd 1:0:0:0: [sdg] Add. Sense: Device internal reset
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810111515600, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810111515600 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011141fc00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81011141fc00 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011141fc00, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81011141fc00 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011141f340
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81011141f340 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011141f340, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81011141f340 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011d9d00c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d00c0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d00c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d00c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907300
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907300 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907300, timeleft: 9999
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907300 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81007e50bb00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81007e50bb00 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81007e50bb00, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81007e50bb00 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810050cb7400
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810050cb7400 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050cb7400, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810050cb7400 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907840
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907840 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907840, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907840 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810124c34cc0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810124c34cc0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124c34cc0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810124c34cc0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81005e9599c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81005e9599c0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005e9599c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81005e9599c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81005ac9d700
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81005ac9d700 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005ac9d700, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81005ac9d700 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81004bdad8c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81004bdad8c0 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004bdad8c0, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81004bdad8c0 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907140
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907140 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907140, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907140 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810124d5a800
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_done scmd: ffff810124d5a800 result: 0
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124d5a800, timeleft: 10000
Apr 26 11:58:44 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_tur: scmd ffff810124d5a800 rtn 2002
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011d9d0600
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81012c1f1480
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81014d0215c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011d9d0d00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810124c784c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81014d021780
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810124c34400
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810124d5a640
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81006fb4c700
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff8101115157c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810111515d00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810111515b40
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011d8f98c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810111515600
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011141fc00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011141f340
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011d9d00c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907300
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81007e50bb00
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810050cb7400
Apr 26 11:58:44 elm3c29 kernel: device-mapper: multipath: Failing path 8:112.
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907840
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810124c34cc0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81005e9599c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81005ac9d700
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81004bdad8c0
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907140
Apr 26 11:58:44 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810124d5a800
Apr 26 11:58:44 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 11:58:44 elm3c29 kernel: Error handler scsi_eh_1 sleeping
Apr 26 11:58:44 elm3c29 multipathd: dm-5: add map (uevent) 
Apr 26 11:58:44 elm3c29 multipathd: dm-5: devmap already registered 
Apr 26 11:58:49 elm3c29 multipathd: sdh: rdac checker reports path is down 
Apr 26 11:58:49 elm3c29 multipathd: 8:112: reinstated 
Apr 26 11:58:49 elm3c29 multipathd: mpath1: remaining active paths: 2 
Apr 26 11:58:49 elm3c29 multipathd: dm-5: add map (uevent) 
Apr 26 11:58:49 elm3c29 multipathd: dm-5: devmap already registered 
Apr 26 12:30:08 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 13:30:51 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 13:58:18 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 13:58:18 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 13:58:18 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 13:58:31 elm3c29 kernel: scsi 1:0:0:31: Done: TIMEOUT
Apr 26 13:58:31 elm3c29 kernel: scsi 1:0:0:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 13:58:31 elm3c29 kernel: scsi 1:0:0:31: CDB: Read(6): 08 00 02 00 01 00
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:8: [sds] Done: TIMEOUT
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:8: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:8: [sds] CDB: Read(10): 28 00 01 a5 88 38 00 00 08 00
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 a8 00 00 08 00
Apr 26 13:59:16 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:40 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 14:00:40 elm3c29 multipathd: sdg: rdac checker reports path is down 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 java: SGIO host_status=0x8
Apr 26 14:00:57 elm3c29 multipathd: checker failed path 8:96 in map mpath0 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 70 00 00 08 00
Apr 26 14:00:57 elm3c29 java: SGIO driver_status=0x8
Apr 26 14:00:57 elm3c29 multipathd: mpath0: remaining active paths: 1 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 80 00 00 08 00
Apr 26 14:00:57 elm3c29 multipathd: sdg: rdac checker reports path is down 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 multipathd: 8:96: reinstated 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 multipathd: mpath0: remaining active paths: 2 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 b8 00 00 10 00
Apr 26 14:00:57 elm3c29 multipathd: mpath0: switch to path group #1 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 multipathd: mpath0: switch to path group #1 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 98 00 00 10 00
Apr 26 14:00:57 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 b0 00 00 08 00
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f2 c8 00 01 b0 00
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f6 98 00 00 80 00
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 f9 38 00 00 80 00
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 fb d8 00 00 08 00
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 3f 00 00 10 00
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 14:00:57 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 57 00 00 08 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 7f 00 00 10 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Write(10): 2a 00 00 32 40 97 00 00 08 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 fb e0 00 00 78 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 84 fe 78 00 00 80 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 85 01 18 00 00 80 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 85 03 b8 00 00 08 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 85 03 c0 00 00 78 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 85 06 58 00 00 80 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 85 09 00 00 00 78 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Write(10): 2a 00 00 85 0b a0 00 00 08 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: TIMEOUT
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Read(10): 28 00 00 15 40 a7 00 00 08 00
Apr 26 14:00:58 elm3c29 kernel: Error handler scsi_eh_1 waking up
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 6
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 18
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:8: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 14:00:58 elm3c29 kernel: scsi 1:0:0:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 14:00:58 elm3c29 kernel: Total of 26 commands on 4 devices require eh work
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810050ca7640
Apr 26 14:00:58 elm3c29 kernel: qla2xxx_eh_abort(1): aborting sp ffff810050cbad40 from RISC. pid=12723180.
Apr 26 14:00:58 elm3c29 kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 26 14:00:58 elm3c29 kernel: qla2x00_mailbox_command(1): timeout calling abort_isp
Apr 26 14:00:58 elm3c29 kernel: qla2xxx 0000:03:05.1: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 14:00:58 elm3c29 kernel: qla2xxx 0000:03:05.1: Performing ISP error recovery - ha= ffff81007e76c610.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): **** Load RISC code ****
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Verifying Checksum of loaded RISC code.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Checksum OK, start firmware.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Issue init firmware.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): fcport-0 - port retry count: 29 remaining
Apr 26 14:00:58 elm3c29 kernel: scsi(1): fcport-1 - port retry count: 29 remaining
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Asynchronous P2P MODE received.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Asynchronous LOOP UP (4 Gbps).
Apr 26 14:00:58 elm3c29 kernel: qla2xxx 0000:03:05.1: LOOP UP detected (4 Gbps).
Apr 26 14:00:58 elm3c29 kernel: scsi(1): F/W Ready - OK 
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Port database changed ffff 0006 0000.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): fw_state=3 curr time=1050b59ff.
Apr 26 14:00:58 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Configure loop -- dpc flags =0x4080048
Apr 26 14:00:58 elm3c29 kernel: scsi(1): RSCN queue entry[0] = [00/000000].
Apr 26 14:00:58 elm3c29 kernel: scsi(1): device_resync: rscn overflow.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): RFT_ID exiting normally.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): RFF_ID exiting normally.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): RNN_ID exiting normally.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): RSNN_NN exiting normally.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): GID_PT entry - nn 200400a0b8421b14 pn 200500a0b8421b15 portid=010000.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): GID_PT entry - nn 2001001b32252166 pn 2101001b32252166 portid=010400.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): GID_PT entry - nn 2001000e1180034c pn 2002000e1180034c portid=010fe1.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): GPSC failed, rejected request:
Apr 26 14:00:58 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 14:00:58 elm3c29 kernel: --------------------------------------------------------------
Apr 26 14:00:58 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 14:00:58 elm3c29 kernel: scsi(1): GPSC command unsupported, disabling query...
Apr 26 14:00:58 elm3c29 kernel: qla24xx_fabric_logout(1): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): device wrap (010fe1)
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Trying Fabric Login w/loop id 0x0081 for port 010000.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): Trying Fabric Login w/loop id 0x0082 for port 010fe1.
Apr 26 14:00:58 elm3c29 kernel: scsi(1): LOOP READY
Apr 26 14:00:58 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 14:00:58 elm3c29 kernel: qla2x00_abort_isp(1): exiting.
Apr 26 14:00:58 elm3c29 kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 26 14:00:58 elm3c29 kernel: qla2x00_mailbox_command(1): finished abort_isp
Apr 26 14:00:58 elm3c29 kernel: qla2x00_mailbox_command(1): **** FAILED. mbx0=54, mbx1=0, mbx2=7e4f, cmd=54 ****
Apr 26 14:00:58 elm3c29 kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 26 14:00:58 elm3c29 kernel: qla2x00_issue_iocb(1): failed rval 0x100
Apr 26 14:00:58 elm3c29 kernel: qla24xx_abort_command(1): failed to issue IOCB (100).
Apr 26 14:00:58 elm3c29 kernel: qla2xxx_eh_abort(1): abort_command mbx failed.
Apr 26 14:00:58 elm3c29 kernel: qla2xxx 0000:03:05.1: scsi(1:0:0): Abort command issued -- 0 c223ec 2002.
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050ca7640 result: 2
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Done: SUCCESS
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Sense Key : Unit Attention [current] 
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:0: [sdg] Add. Sense: Device internal reset
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050ca7640, timeleft: 9998
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050ca7640 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81010b235c40
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81010b235c40 result: 2
Apr 26 14:00:58 elm3c29 kernel: scsi 1:0:0:31: Done: SUCCESS
Apr 26 14:00:58 elm3c29 kernel: scsi 1:0:0:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: scsi 1:0:0:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 14:00:58 elm3c29 kernel: scsi 1:0:0:31: Sense Key : Unit Attention [current] 
Apr 26 14:00:58 elm3c29 kernel: scsi 1:0:0:31: Add. Sense: Device internal reset
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010b235c40, timeleft: 9999
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81010b235c40 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff8101115150c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff8101115150c0 result: 2
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:8: [sds] Done: SUCCESS
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:8: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:8: [sds] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:8: [sds] Sense Key : Unit Attention [current] 
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:8: [sds] Add. Sense: Device internal reset
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8101115150c0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff8101115150c0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81010c7850c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81010c7850c0 result: 2
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Done: SUCCESS
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Sense Key : Unit Attention [current] 
Apr 26 14:00:58 elm3c29 kernel: sd 1:0:0:5: [sdp] Add. Sense: Device internal reset
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010c7850c0, timeleft: 9999
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81010c7850c0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810052571dc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810052571dc0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810052571dc0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810052571dc0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810124d5a9c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810124d5a9c0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124d5a9c0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810124d5a9c0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81004a363d00
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81004a363d00 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004a363d00, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81004a363d00 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810072d51bc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810072d51bc0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810072d51bc0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810072d51bc0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810146d60240
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810146d60240 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810146d60240, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810146d60240 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81001ce3a840
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81001ce3a840 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81001ce3a840, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81001ce3a840 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907d80
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907d80 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907d80, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907d80 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81001ce3a4c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81001ce3a4c0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81001ce3a4c0, timeleft: 9999
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81001ce3a4c0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907840
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907840 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907840, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907840 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810130a43dc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810130a43dc0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810130a43dc0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810130a43dc0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011061da00
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81011061da00 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011061da00, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81011061da00 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81010c785600
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81010c785600 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010c785600, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81010c785600 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81011d9d0d00
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d0d00 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d0d00, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d0d00 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81004a2d1280
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81004a2d1280 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004a2d1280, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81004a2d1280 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81006f92c140
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81006f92c140 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81006f92c140, timeleft: 9999
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81006f92c140 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810052571a40
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810052571a40 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810052571a40, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810052571a40 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e9074c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e9074c0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e9074c0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e9074c0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810050d3e440
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810050d3e440 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050d3e440, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810050d3e440 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff810065d62d80
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff810065d62d80 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810065d62d80, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff810065d62d80 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907140
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907140 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907140, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907140 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81003e907bc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81003e907bc0 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81003e907bc0, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81003e907bc0 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: aborting cmd:0xffff81010b235700
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_done scmd: ffff81010b235700 result: 0
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010b235700, timeleft: 10000
Apr 26 14:00:58 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_tur: scmd ffff81010b235700 rtn 2002
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810050ca7640
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81010b235c40
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff8101115150c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81010c7850c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810052571dc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810124d5a9c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81004a363d00
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810072d51bc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810146d60240
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81001ce3a840
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907d80
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81001ce3a4c0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907840
Apr 26 14:00:58 elm3c29 kernel: device-mapper: multipath: Failing path 8:96.
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810130a43dc0
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011061da00
Apr 26 14:00:58 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81010c785600
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81011d9d0d00
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81004a2d1280
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81006f92c140
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810052571a40
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e9074c0
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810050d3e440
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff810065d62d80
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907140
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81003e907bc0
Apr 26 14:00:59 elm3c29 kernel: scsi_eh_1: flush finish cmd: ffff81010b235700
Apr 26 14:00:59 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 14:00:59 elm3c29 kernel: Error handler scsi_eh_1 sleeping
Apr 26 14:00:59 elm3c29 kernel: sd 0:0:1:0: queueing MODE_SELECT command.
Apr 26 14:00:59 elm3c29 kernel: sd 1:0:0:0: queueing MODE_SELECT command.
Apr 26 14:01:08 elm3c29 multipathd: sdg: rdac checker reports path is down 
Apr 26 14:01:08 elm3c29 multipathd: 8:96: reinstated 
Apr 26 14:32:50 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 15:33:35 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 15:57:54 elm3c29 kernel: scsi 0:0:1:31: Done: TIMEOUT
Apr 26 15:57:54 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:57:54 elm3c29 kernel: scsi 0:0:1:31: CDB: Read(6): 08 00 02 00 01 00
Apr 26 15:58:48 elm3c29 kernel: sd 0:0:1:0: [sda] Done: TIMEOUT
Apr 26 15:58:48 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:58:48 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: TIMEOUT
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Read(10): 28 00 00 7b 1f a8 00 00 08 00
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 63 eb f8 00 03 e0 00
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 63 ef e0 00 03 e0 00
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 63 f3 c8 00 03 e0 00
Apr 26 15:59:34 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 66 b8 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 69 98 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 6c 78 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 6f 58 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 72 38 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 75 18 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 63 84 20 00 03 48 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 80 a8 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 83 90 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 86 78 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 89 60 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 77 f8 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 7a d8 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 3d 7d c0 00 00 08 00
Apr 26 15:59:35 elm3c29 kernel: Error handler scsi_eh_0 waking up
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 17
Apr 26 15:59:35 elm3c29 kernel: sd 0:0:1:7: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 15:59:35 elm3c29 kernel: scsi 0:0:1:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 15:59:35 elm3c29 kernel: Total of 20 commands on 4 devices require eh work
Apr 26 15:59:35 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81005d57d8c0
Apr 26 15:59:35 elm3c29 kernel: qla2xxx_eh_abort(0): aborting sp ffff810037bf1680 from RISC. pid=13286121.
Apr 26 16:00:04 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 16:00:04 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 16:00:04 elm3c29 kernel: qla2xxx 0000:03:05.0: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 16:00:04 elm3c29 kernel: qla2xxx 0000:03:05.0: Performing ISP error recovery - ha= ffff81007ea44610.
Apr 26 16:00:04 elm3c29 kernel: scsi(0): **** Load RISC code ****
Apr 26 16:00:04 elm3c29 kernel: scsi(0): Verifying Checksum of loaded RISC code.
Apr 26 16:00:04 elm3c29 kernel: scsi(0): Checksum OK, start firmware.
Apr 26 16:00:04 elm3c29 kernel: scsi(0): Issue init firmware.
Apr 26 16:00:04 elm3c29 kernel: scsi(0): fcport-0 - port retry count: 29 remaining
Apr 26 16:00:04 elm3c29 kernel: scsi(0): fcport-1 - port retry count: 29 remaining
Apr 26 16:00:05 elm3c29 kernel: scsi(0): Asynchronous P2P MODE received.
Apr 26 16:00:05 elm3c29 kernel: scsi(0): Asynchronous LOOP UP (4 Gbps).
Apr 26 16:00:05 elm3c29 kernel: qla2xxx 0000:03:05.0: LOOP UP detected (4 Gbps).
Apr 26 16:00:05 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE.
Apr 26 16:00:05 elm3c29 kernel: scsi(0): Port database changed ffff 0006 0000.
Apr 26 16:00:05 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 16:00:05 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 16:00:11 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 16:00:19 elm3c29 java: SGIO host_status=0x8
Apr 26 16:00:19 elm3c29 multipathd: checker failed path 8:0 in map mpath0 
Apr 26 16:00:20 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 16:00:21 elm3c29 java: SGIO driver_status=0x8
Apr 26 16:00:21 elm3c29 multipathd: mpath0: remaining active paths: 1 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): F/W Ready - OK 
Apr 26 16:00:21 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): fw_state=3 curr time=10578adb1.
Apr 26 16:00:21 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 16:00:21 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 16:00:21 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): Configure loop -- dpc flags =0x4080048
Apr 26 16:00:21 elm3c29 multipathd: 8:0: reinstated 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): RSCN queue entry[0] = [00/000000].
Apr 26 16:00:21 elm3c29 multipathd: mpath0: remaining active paths: 2 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): device_resync: rscn overflow.
Apr 26 16:00:21 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): RFT_ID exiting normally.
Apr 26 16:00:21 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 16:00:21 elm3c29 kernel: scsi(0): RFF_ID exiting normally.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): RNN_ID exiting normally.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): RSNN_NN exiting normally.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): GID_PT entry - nn 2000001b32052166 pn 2100001b32052166 portid=010400.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): GID_PT entry - nn 2001000e1180034c pn 2001000e1180034c portid=011226.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): GID_PT entry - nn 200400a0b8421b14 pn 200400a0b8421b15 portid=011300.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): GPSC failed, rejected request:
Apr 26 16:00:21 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 16:00:21 elm3c29 kernel: --------------------------------------------------------------
Apr 26 16:00:21 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 16:00:21 elm3c29 kernel: scsi(0): GPSC command unsupported, disabling query...
Apr 26 16:00:21 elm3c29 kernel: qla24xx_fabric_logout(0): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): device wrap (011300)
Apr 26 16:00:21 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 011226.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0082 for port 011300.
Apr 26 16:00:21 elm3c29 kernel: scsi(0): LOOP READY
Apr 26 16:00:21 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 16:00:21 elm3c29 kernel: qla2x00_abort_isp(0): exiting.
Apr 26 16:00:21 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 16:00:21 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 16:00:21 elm3c29 kernel: qla2x00_mailbox_command(0): **** FAILED. mbx0=54, mbx1=0, mbx2=37bf, cmd=54 ****
Apr 26 16:00:21 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 16:00:21 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 16:00:21 elm3c29 kernel: qla24xx_abort_command(0): failed to issue IOCB (100).
Apr 26 16:00:21 elm3c29 kernel: qla2xxx_eh_abort(0): abort_command mbx failed.
Apr 26 16:00:21 elm3c29 kernel: qla2xxx 0000:03:05.0: scsi(0:1:31): Abort command issued -- 0 cabae9 2002.
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff81005d57d8c0 result: 2
Apr 26 16:00:21 elm3c29 kernel: scsi 0:0:1:31: Done: SUCCESS
Apr 26 16:00:21 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 16:00:21 elm3c29 kernel: scsi 0:0:1:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 16:00:21 elm3c29 kernel: scsi 0:0:1:31: Sense Key : Unit Attention [current] 
Apr 26 16:00:21 elm3c29 kernel: scsi 0:0:1:31: Add. Sense: Device internal reset
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005d57d8c0, timeleft: 9997
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff81005d57d8c0 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d9d07c0
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d07c0 result: 2
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:0: [sda] Done: SUCCESS
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:0: [sda] Sense Key : Unit Attention [current] 
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:0: [sda] Add. Sense: Device internal reset
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d07c0, timeleft: 10000
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d07c0 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050ca3540
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff810050ca3540 result: 2
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: SUCCESS
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:7: [sdk] Sense Key : Unit Attention [current] 
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:7: [sdk] Add. Sense: Device internal reset
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050ca3540, timeleft: 9999
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff810050ca3540 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100ac586b80
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff8100ac586b80 result: 2
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:4: [sde] Done: SUCCESS
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:4: [sde] Sense Key : Unit Attention [current] 
Apr 26 16:00:21 elm3c29 kernel: sd 0:0:1:4: [sde] Add. Sense: Device internal reset
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100ac586b80, timeleft: 10000
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff8100ac586b80 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8101115e4c40
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff8101115e4c40 result: 0
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8101115e4c40, timeleft: 10000
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff8101115e4c40 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81009d041a40
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff81009d041a40 result: 0
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81009d041a40, timeleft: 10000
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff81009d041a40 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014e03c300
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff81014e03c300 result: 0
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014e03c300, timeleft: 10000
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff81014e03c300 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81014e03ca00
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff81014e03ca00 result: 0
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81014e03ca00, timeleft: 9999
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff81014e03ca00 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8101115e4700
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_done scmd: ffff8101115e4700 result: 0
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8101115e4700, timeleft: 10000
Apr 26 16:00:21 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_tur: scmd ffff8101115e4700 rtn 2002
Apr 26 16:00:21 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81009259bb00
Apr 26 16:00:22 elm3c29 kernel: scsi_eh_done scmd: ffff81009259bb00 result: 0
Apr 26 16:00:22 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81009259bb00, timeleft: 10000
Apr 26 16:00:24 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:25 elm3c29 kernel: scsi_eh_tur: scmd ffff81009259bb00 rtn 2002
Apr 26 16:00:27 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d9d0980
Apr 26 16:00:29 elm3c29 kernel: scsi_eh_done scmd: ffff81011d9d0980 result: 0
Apr 26 16:00:31 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d9d0980, timeleft: 10000
Apr 26 16:00:32 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:33 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d9d0980 rtn 2002
Apr 26 16:00:36 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810092435140
Apr 26 16:00:38 elm3c29 kernel: scsi_eh_done scmd: ffff810092435140 result: 0
Apr 26 16:00:39 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810092435140, timeleft: 10000
Apr 26 16:00:40 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:40 elm3c29 kernel: scsi_eh_tur: scmd ffff810092435140 rtn 2002
Apr 26 16:00:40 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810092435840
Apr 26 16:00:40 elm3c29 kernel: scsi_eh_done scmd: ffff810092435840 result: 0
Apr 26 16:00:40 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810092435840, timeleft: 10000
Apr 26 16:00:41 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:43 elm3c29 kernel: scsi_eh_tur: scmd ffff810092435840 rtn 2002
Apr 26 16:00:44 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810137d7bd00
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff810137d7bd00 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810137d7bd00, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff810137d7bd00 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810130a43c00
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff810130a43c00 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810130a43c00, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff810130a43c00 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810130a43a40
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff810130a43a40 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810130a43a40, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff810130a43a40 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81013047f5c0
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff81013047f5c0 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81013047f5c0, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff81013047f5c0 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810124d5a800
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff810124d5a800 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810124d5a800, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff810124d5a800 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810137d7b7c0
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff810137d7b7c0 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810137d7b7c0, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff810137d7b7c0 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810110764c40
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_done scmd: ffff810110764c40 result: 0
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810110764c40, timeleft: 10000
Apr 26 16:00:45 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_tur: scmd ffff810110764c40 rtn 2002
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81005d57d8c0
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d9d07c0
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050ca3540
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100ac586b80
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8101115e4c40
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81009d041a40
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014e03c300
Apr 26 16:00:45 elm3c29 kernel: device-mapper: multipath: Failing path 8:0.
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81014e03ca00
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8101115e4700
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81009259bb00
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d9d0980
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810092435140
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810092435840
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810137d7bd00
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810130a43c00
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810130a43a40
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81013047f5c0
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810124d5a800
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810137d7b7c0
Apr 26 16:00:45 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810110764c40
Apr 26 16:00:45 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 16:00:45 elm3c29 kernel: Error handler scsi_eh_0 sleeping
Apr 26 16:29:42 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 17:31:03 elm3c29 kernel: scsi 0:0:1:31: Done: TIMEOUT
Apr 26 17:31:03 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:31:03 elm3c29 kernel: scsi 0:0:1:31: CDB: Read(6): 08 00 03 0e 01 00
Apr 26 17:31:11 elm3c29 kernel: scsi 0:0:1:31: Done: TIMEOUT
Apr 26 17:31:11 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:31:11 elm3c29 kernel: scsi 0:0:1:31: CDB: Inquiry: 12 01 c8 00 ff 00
Apr 26 17:31:52 elm3c29 kernel: sd 0:0:1:0: [sda] Done: TIMEOUT
Apr 26 17:31:52 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:31:52 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: TIMEOUT
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Read(10): 28 00 01 ee 91 e8 00 00 08 00
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e d0 00 00 10 00
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e e0 00 00 08 00
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e f8 00 00 20 00
Apr 26 17:32:42 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:32:48 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:50 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e 58 00 00 08 00
Apr 26 17:32:52 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:32:54 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:56 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e 98 00 00 08 00
Apr 26 17:32:57 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:32:58 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:32:59 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 28 00 00 08 00
Apr 26 17:33:01 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:33:01 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:33:01 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e a0 00 00 08 00
Apr 26 17:33:02 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:33:03 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:33:04 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e c8 00 00 08 00
Apr 26 17:33:08 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:33:11 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:33:11 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e e8 00 00 08 00
Apr 26 17:33:12 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:33:14 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:33:14 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 17:33:14 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 17:33:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 20 00 00 08 00
Apr 26 17:33:42 elm3c29 java: SGIO host_status=0x8
Apr 26 17:33:45 elm3c29 multipathd: checker failed path 8:0 in map mpath0 
Apr 26 17:33:50 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:33:14 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 17:33:52 elm3c29 multipathd: mpath0: remaining active paths: 1 
Apr 26 17:33:55 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:33:51 elm3c29 java: SGIO driver_status=0x8
Apr 26 17:34:10 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 17:34:15 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6e f0 00 00 08 00
Apr 26 17:34:01 elm3c29 java: SGIO host_status=0x8
Apr 26 17:34:30 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 17:34:30 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 17:34:34 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:34:37 elm3c29 java: SGIO driver_status=0x8
Apr 26 17:34:45 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 17:34:52 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:34:57 elm3c29 java: Error performing inquiry on device: 11.
Apr 26 17:35:00 elm3c29 multipathd: 8:0: reinstated 
Apr 26 17:35:03 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 18 00 00 08 00
Apr 26 17:35:11 elm3c29 multipathd: mpath0: remaining active paths: 2 
Apr 26 17:35:12 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:35:13 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 17:35:16 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:35:18 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 17:35:25 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 30 00 00 08 00
Apr 26 17:35:34 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:35:37 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:35:39 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 38 00 00 08 00
Apr 26 17:35:45 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:35:46 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:35:49 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 40 00 00 38 00
Apr 26 17:35:53 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:35:58 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:36:07 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 6f 80 00 01 88 00
Apr 26 17:36:13 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:36:21 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:36:25 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 71 10 00 01 88 00
Apr 26 17:36:29 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 17:36:31 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:36:31 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 1a 72 a0 00 00 08 00
Apr 26 17:36:34 elm3c29 kernel: Error handler scsi_eh_0 waking up
Apr 26 17:36:35 elm3c29 kernel: sd 0:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 17:36:36 elm3c29 kernel: sd 0:0:1:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 18
Apr 26 17:36:37 elm3c29 kernel: sd 0:0:1:7: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 17:36:41 elm3c29 kernel: scsi 0:0:1:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 2
Apr 26 17:36:57 elm3c29 kernel: Total of 22 commands on 4 devices require eh work
Apr 26 17:37:02 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81004a5f4b80
Apr 26 17:37:07 elm3c29 kernel: qla2xxx_eh_abort(0): aborting sp ffff810069fb8c80 from RISC. pid=13926702.
Apr 26 17:37:07 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 17:37:11 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 17:37:14 elm3c29 kernel: qla2xxx 0000:03:05.0: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 17:37:16 elm3c29 kernel: qla2xxx 0000:03:05.0: Performing ISP error recovery - ha= ffff81007ea44610.
Apr 26 17:37:17 elm3c29 kernel: scsi(0): **** Load RISC code ****
Apr 26 17:37:19 elm3c29 kernel: scsi(0): Verifying Checksum of loaded RISC code.
Apr 26 17:37:22 elm3c29 kernel: scsi(0): Checksum OK, start firmware.
Apr 26 17:37:24 elm3c29 kernel: scsi(0): Issue init firmware.
Apr 26 17:37:28 elm3c29 kernel: scsi(0): Asynchronous P2P MODE received.
Apr 26 17:37:30 elm3c29 kernel: scsi(0): F/W Ready - OK 
Apr 26 17:37:33 elm3c29 kernel: scsi(0): Asynchronous LOOP UP (4 Gbps).
Apr 26 17:37:36 elm3c29 kernel: qla2xxx 0000:03:05.0: LOOP UP detected (4 Gbps).
Apr 26 17:37:38 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE.
Apr 26 17:37:39 elm3c29 kernel: scsi(0): Port database changed ffff 0006 0000.
Apr 26 17:37:39 elm3c29 kernel: scsi(0): fw_state=3 curr time=105cdf32d.
Apr 26 17:37:43 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 17:37:44 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 17:37:45 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 17:37:47 elm3c29 kernel: scsi(0): Configure loop -- dpc flags =0x4080048
Apr 26 17:37:48 elm3c29 kernel: scsi(0): RSCN queue entry[0] = [00/000000].
Apr 26 17:37:50 elm3c29 kernel: scsi(0): device_resync: rscn overflow.
Apr 26 17:37:53 elm3c29 kernel: scsi(0): RFT_ID exiting normally.
Apr 26 17:37:54 elm3c29 kernel: scsi(0): RFF_ID exiting normally.
Apr 26 17:37:56 elm3c29 kernel: scsi(0): RNN_ID exiting normally.
Apr 26 17:38:00 elm3c29 kernel: scsi(0): RSNN_NN exiting normally.
Apr 26 17:38:02 elm3c29 kernel: scsi(0): fcport-0 - port retry count: 29 remaining
Apr 26 17:38:05 elm3c29 kernel: scsi(0): fcport-1 - port retry count: 29 remaining
Apr 26 17:38:05 elm3c29 kernel: scsi(0): GID_PT entry - nn 2000001b32052166 pn 2100001b32052166 portid=010400.
Apr 26 17:38:05 elm3c29 kernel: scsi(0): GID_PT entry - nn 2001000e1180034c pn 2001000e1180034c portid=011226.
Apr 26 17:38:05 elm3c29 kernel: scsi(0): GID_PT entry - nn 200400a0b8421b14 pn 200400a0b8421b15 portid=011300.
Apr 26 17:38:05 elm3c29 kernel: scsi(0): GPSC failed, rejected request:
Apr 26 17:38:05 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 17:38:05 elm3c29 kernel: --------------------------------------------------------------
Apr 26 17:38:05 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 17:38:05 elm3c29 kernel: scsi(0): GPSC command unsupported, disabling query...
Apr 26 17:38:05 elm3c29 kernel: qla24xx_fabric_logout(0): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 17:38:05 elm3c29 kernel: scsi(0): device wrap (011300)
Apr 26 17:38:05 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 011226.
Apr 26 17:38:05 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0082 for port 011300.
Apr 26 17:38:05 elm3c29 kernel: scsi(0): LOOP READY
Apr 26 17:38:05 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 17:38:05 elm3c29 kernel: qla2x00_abort_isp(0): exiting.
Apr 26 17:38:05 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 17:38:05 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 17:38:05 elm3c29 kernel: qla2x00_mailbox_command(0): **** FAILED. mbx0=54, mbx1=0, mbx2=37bf, cmd=54 ****
Apr 26 17:38:05 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 17:38:05 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 17:38:05 elm3c29 kernel: qla24xx_abort_command(0): failed to issue IOCB (100).
Apr 26 17:38:05 elm3c29 kernel: qla2xxx_eh_abort(0): abort_command mbx failed.
Apr 26 17:38:05 elm3c29 kernel: qla2xxx 0000:03:05.0: scsi(0:1:31): Abort command issued -- 0 d4812e 2002.
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_done scmd: ffff81004a5f4b80 result: 2
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Done: SUCCESS
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Sense Key : Unit Attention [current] 
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Add. Sense: Device internal reset
Apr 26 17:38:05 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004a5f4b80, timeleft: 9996
Apr 26 17:38:05 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_tur: scmd ffff81004a5f4b80 rtn 2002
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810024d79340
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_done scmd: ffff810024d79340 result: 2
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Done: SUCCESS
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Sense Key : Unit Attention [current] 
Apr 26 17:38:05 elm3c29 kernel: scsi 0:0:1:31: Add. Sense: Mode parameters changed
Apr 26 17:38:05 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810024d79340, timeleft: 9999
Apr 26 17:38:05 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_tur: scmd ffff810024d79340 rtn 2002
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100638d1240
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_done scmd: ffff8100638d1240 result: 2
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:0: [sda] Done: SUCCESS
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:0: [sda] Sense Key : Unit Attention [current] 
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:0: [sda] Add. Sense: Device internal reset
Apr 26 17:38:05 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100638d1240, timeleft: 10000
Apr 26 17:38:05 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_tur: scmd ffff8100638d1240 rtn 2002
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81005ac14940
Apr 26 17:38:05 elm3c29 kernel: scsi_eh_done scmd: ffff81005ac14940 result: 2
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: SUCCESS
Apr 26 17:38:05 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:7: [sdk] Sense Key : Unit Attention [current] 
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:7: [sdk] Add. Sense: Device internal reset
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005ac14940, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81005ac14940 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810050ca3a80
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810050ca3a80 result: 2
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:4: [sde] Done: SUCCESS
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:4: [sde] Sense Key : Unit Attention [current] 
Apr 26 17:38:06 elm3c29 kernel: sd 0:0:1:4: [sde] Add. Sense: Device internal reset
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810050ca3a80, timeleft: 9999
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810050ca3a80 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810071d2d480
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810071d2d480 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810071d2d480, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810071d2d480 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81007e50b080
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff81007e50b080 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81007e50b080, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81007e50b080 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81005ac14400
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff81005ac14400 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81005ac14400, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81005ac14400 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81004a5f4640
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff81004a5f4640 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004a5f4640, timeleft: 9999
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81004a5f4640 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810021993180
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810021993180 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810021993180, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810021993180 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81006f915440
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff81006f915440 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81006f915440, timeleft: 9999
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81006f915440 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810024d79dc0
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810024d79dc0 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810024d79dc0, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810024d79dc0 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810148435600
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810148435600 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810148435600, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810148435600 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810130a43180
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810130a43180 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810130a43180, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810130a43180 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810137d7b440
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810137d7b440 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810137d7b440, timeleft: 9999
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810137d7b440 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81010b3d0080
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff81010b3d0080 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010b3d0080, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81010b3d0080 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810130a43880
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810130a43880 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810130a43880, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810130a43880 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81004bd10700
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff81004bd10700 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81004bd10700, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff81004bd10700 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810021993c00
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810021993c00 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810021993c00, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810021993c00 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810021993500
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810021993500 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810021993500, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810021993500 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff8100638d1080
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff8100638d1080 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff8100638d1080, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff8100638d1080 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810069e8f8c0
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_done scmd: ffff810069e8f8c0 result: 0
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810069e8f8c0, timeleft: 10000
Apr 26 17:38:06 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_tur: scmd ffff810069e8f8c0 rtn 2002
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81004a5f4b80
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810024d79340
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100638d1240
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81005ac14940
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810050ca3a80
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810071d2d480
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81007e50b080
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81005ac14400
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81004a5f4640
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810021993180
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81006f915440
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810024d79dc0
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810148435600
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810130a43180
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810137d7b440
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81010b3d0080
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810130a43880
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81004bd10700
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810021993c00
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810021993500
Apr 26 17:38:06 elm3c29 kernel: device-mapper: multipath: Failing path 8:0.
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff8100638d1080
Apr 26 17:38:06 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810069e8f8c0
Apr 26 17:38:06 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 17:38:06 elm3c29 kernel: Error handler scsi_eh_0 sleeping
Apr 26 17:52:40 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 17:53:12 elm3c29 last message repeated 4 times
Apr 26 17:54:20 elm3c29 last message repeated 6 times
Apr 26 17:55:32 elm3c29 last message repeated 4 times
Apr 26 17:56:44 elm3c29 last message repeated 5 times
Apr 26 17:58:03 elm3c29 last message repeated 6 times
Apr 26 17:59:14 elm3c29 last message repeated 5 times
Apr 26 18:00:23 elm3c29 last message repeated 5 times
Apr 26 18:01:25 elm3c29 last message repeated 4 times
Apr 26 18:02:28 elm3c29 last message repeated 4 times
Apr 26 18:03:39 elm3c29 last message repeated 4 times
Apr 26 18:04:50 elm3c29 last message repeated 5 times
Apr 26 18:06:06 elm3c29 last message repeated 6 times
Apr 26 18:07:19 elm3c29 last message repeated 6 times
Apr 26 18:08:27 elm3c29 last message repeated 5 times
Apr 26 18:09:28 elm3c29 last message repeated 6 times
Apr 26 18:10:34 elm3c29 last message repeated 5 times
Apr 26 18:11:38 elm3c29 last message repeated 6 times
Apr 26 18:12:43 elm3c29 last message repeated 5 times
Apr 26 18:13:48 elm3c29 last message repeated 4 times
Apr 26 18:14:50 elm3c29 last message repeated 5 times
Apr 26 18:15:53 elm3c29 last message repeated 5 times
Apr 26 18:16:57 elm3c29 last message repeated 5 times
Apr 26 18:18:07 elm3c29 last message repeated 5 times
Apr 26 18:19:19 elm3c29 last message repeated 5 times
Apr 26 18:20:27 elm3c29 last message repeated 6 times
Apr 26 18:21:29 elm3c29 last message repeated 4 times
Apr 26 18:22:34 elm3c29 last message repeated 5 times
Apr 26 18:23:43 elm3c29 last message repeated 4 times
Apr 26 18:24:54 elm3c29 last message repeated 5 times
Apr 26 18:26:09 elm3c29 last message repeated 5 times
Apr 26 18:27:20 elm3c29 last message repeated 4 times
Apr 26 18:28:27 elm3c29 last message repeated 4 times
Apr 26 18:29:40 elm3c29 last message repeated 5 times
Apr 26 18:30:41 elm3c29 last message repeated 5 times
Apr 26 18:31:43 elm3c29 last message repeated 6 times
Apr 26 18:32:46 elm3c29 last message repeated 4 times
Apr 26 18:33:22 elm3c29 last message repeated 2 times
Apr 26 18:33:26 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 18:33:35 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 18:34:24 elm3c29 last message repeated 3 times
Apr 26 18:35:25 elm3c29 last message repeated 5 times
Apr 26 18:36:32 elm3c29 last message repeated 4 times
Apr 26 18:37:41 elm3c29 last message repeated 7 times
Apr 26 18:38:52 elm3c29 last message repeated 5 times
Apr 26 18:39:55 elm3c29 last message repeated 4 times
Apr 26 18:41:09 elm3c29 last message repeated 5 times
Apr 26 18:42:17 elm3c29 last message repeated 6 times
Apr 26 18:43:22 elm3c29 last message repeated 5 times
Apr 26 18:44:25 elm3c29 last message repeated 6 times
Apr 26 18:45:37 elm3c29 last message repeated 4 times
Apr 26 18:46:41 elm3c29 last message repeated 5 times
Apr 26 18:47:50 elm3c29 last message repeated 5 times
Apr 26 18:48:56 elm3c29 last message repeated 5 times
Apr 26 18:50:00 elm3c29 last message repeated 4 times
Apr 26 18:51:09 elm3c29 last message repeated 5 times
Apr 26 18:52:11 elm3c29 last message repeated 4 times
Apr 26 18:53:12 elm3c29 last message repeated 5 times
Apr 26 18:54:15 elm3c29 last message repeated 6 times
Apr 26 18:55:16 elm3c29 last message repeated 4 times
Apr 26 18:56:17 elm3c29 last message repeated 5 times
Apr 26 18:57:21 elm3c29 last message repeated 4 times
Apr 26 18:58:27 elm3c29 last message repeated 5 times
Apr 26 18:59:36 elm3c29 last message repeated 5 times
Apr 26 19:00:39 elm3c29 last message repeated 5 times
Apr 26 19:01:54 elm3c29 last message repeated 6 times
Apr 26 19:02:57 elm3c29 last message repeated 4 times
Apr 26 19:04:10 elm3c29 last message repeated 5 times
Apr 26 19:05:18 elm3c29 last message repeated 5 times
Apr 26 19:06:25 elm3c29 last message repeated 5 times
Apr 26 19:07:39 elm3c29 last message repeated 5 times
Apr 26 19:08:42 elm3c29 last message repeated 5 times
Apr 26 19:09:53 elm3c29 last message repeated 5 times
Apr 26 19:11:01 elm3c29 last message repeated 5 times
Apr 26 19:12:16 elm3c29 last message repeated 6 times
Apr 26 19:13:18 elm3c29 last message repeated 5 times
Apr 26 19:14:19 elm3c29 last message repeated 5 times
Apr 26 19:15:23 elm3c29 last message repeated 5 times
Apr 26 19:16:28 elm3c29 last message repeated 5 times
Apr 26 19:17:32 elm3c29 last message repeated 5 times
Apr 26 19:18:46 elm3c29 last message repeated 5 times
Apr 26 19:19:59 elm3c29 last message repeated 6 times
Apr 26 19:21:13 elm3c29 last message repeated 6 times
Apr 26 19:22:22 elm3c29 last message repeated 5 times
Apr 26 19:23:28 elm3c29 last message repeated 4 times
Apr 26 19:24:42 elm3c29 last message repeated 5 times
Apr 26 19:25:46 elm3c29 last message repeated 4 times
Apr 26 19:26:53 elm3c29 last message repeated 5 times
Apr 26 19:28:09 elm3c29 last message repeated 4 times
Apr 26 19:29:26 elm3c29 last message repeated 5 times
Apr 26 19:30:38 elm3c29 last message repeated 5 times
Apr 26 19:31:41 elm3c29 last message repeated 4 times
Apr 26 19:32:33 elm3c29 last message repeated 3 times
Apr 26 19:32:35 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 19:32:46 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 19:33:31 elm3c29 last message repeated 3 times
Apr 26 19:34:36 elm3c29 last message repeated 6 times
Apr 26 19:35:46 elm3c29 last message repeated 4 times
Apr 26 19:37:03 elm3c29 last message repeated 5 times
Apr 26 19:38:08 elm3c29 last message repeated 4 times
Apr 26 19:39:16 elm3c29 last message repeated 6 times
Apr 26 19:40:17 elm3c29 last message repeated 4 times
Apr 26 19:41:28 elm3c29 last message repeated 6 times
Apr 26 19:42:30 elm3c29 last message repeated 3 times
Apr 26 19:43:31 elm3c29 last message repeated 4 times
Apr 26 19:44:41 elm3c29 last message repeated 4 times
Apr 26 19:45:57 elm3c29 last message repeated 5 times
Apr 26 19:47:00 elm3c29 last message repeated 4 times
Apr 26 19:48:06 elm3c29 last message repeated 6 times
Apr 26 19:49:21 elm3c29 last message repeated 6 times
Apr 26 19:50:26 elm3c29 last message repeated 5 times
Apr 26 19:51:31 elm3c29 last message repeated 6 times
Apr 26 19:52:38 elm3c29 last message repeated 4 times
Apr 26 19:53:52 elm3c29 last message repeated 5 times
Apr 26 19:54:54 elm3c29 last message repeated 6 times
Apr 26 19:55:55 elm3c29 last message repeated 4 times
Apr 26 19:56:56 elm3c29 last message repeated 4 times
Apr 26 19:58:08 elm3c29 last message repeated 5 times
Apr 26 19:59:16 elm3c29 last message repeated 5 times
Apr 26 20:00:19 elm3c29 last message repeated 4 times
Apr 26 20:01:28 elm3c29 last message repeated 5 times
Apr 26 20:02:37 elm3c29 last message repeated 5 times
Apr 26 20:03:52 elm3c29 last message repeated 6 times
Apr 26 20:05:02 elm3c29 last message repeated 6 times
Apr 26 20:06:08 elm3c29 last message repeated 5 times
Apr 26 20:07:24 elm3c29 last message repeated 5 times
Apr 26 20:08:26 elm3c29 last message repeated 6 times
Apr 26 20:09:29 elm3c29 last message repeated 5 times
Apr 26 20:10:34 elm3c29 last message repeated 6 times
Apr 26 20:11:35 elm3c29 last message repeated 5 times
Apr 26 20:12:52 elm3c29 last message repeated 5 times
Apr 26 20:13:58 elm3c29 last message repeated 4 times
Apr 26 20:15:11 elm3c29 last message repeated 6 times
Apr 26 20:16:17 elm3c29 last message repeated 6 times
Apr 26 20:17:30 elm3c29 last message repeated 5 times
Apr 26 20:18:31 elm3c29 last message repeated 5 times
Apr 26 20:19:33 elm3c29 last message repeated 6 times
Apr 26 20:20:48 elm3c29 last message repeated 5 times
Apr 26 20:22:03 elm3c29 last message repeated 6 times
Apr 26 20:23:19 elm3c29 last message repeated 4 times
Apr 26 20:24:29 elm3c29 last message repeated 5 times
Apr 26 20:25:31 elm3c29 last message repeated 4 times
Apr 26 20:26:33 elm3c29 last message repeated 3 times
Apr 26 20:27:48 elm3c29 last message repeated 5 times
Apr 26 20:28:58 elm3c29 last message repeated 5 times
Apr 26 20:30:04 elm3c29 last message repeated 5 times
Apr 26 20:31:12 elm3c29 last message repeated 6 times
Apr 26 20:32:24 elm3c29 last message repeated 4 times
Apr 26 20:32:33 elm3c29 yum-updatesd-helper: error getting update info: Cannot retrieve repository metadata (repomd.xml) for repository: rhel5-mirror. Please verify its path and try again
Apr 26 20:32:35 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:33:16 elm3c29 last message repeated 3 times
Apr 26 20:34:22 elm3c29 last message repeated 6 times
Apr 26 20:35:31 elm3c29 last message repeated 5 times
Apr 26 20:36:48 elm3c29 last message repeated 6 times
Apr 26 20:37:53 elm3c29 last message repeated 4 times
Apr 26 20:38:59 elm3c29 last message repeated 5 times
Apr 26 20:40:13 elm3c29 last message repeated 5 times
Apr 26 20:41:18 elm3c29 last message repeated 7 times
Apr 26 20:42:24 elm3c29 last message repeated 6 times
Apr 26 20:43:30 elm3c29 last message repeated 5 times
Apr 26 20:44:37 elm3c29 last message repeated 6 times
Apr 26 20:45:43 elm3c29 last message repeated 5 times
Apr 26 20:46:45 elm3c29 last message repeated 6 times
Apr 26 20:47:56 elm3c29 last message repeated 5 times
Apr 26 20:49:01 elm3c29 last message repeated 6 times
Apr 26 20:49:13 elm3c29 kernel: scsi 0:0:1:31: Done: TIMEOUT
Apr 26 20:49:13 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:49:13 elm3c29 kernel: scsi 0:0:1:31: CDB: Read(6): 08 00 02 00 01 00
Apr 26 20:49:14 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:49:48 elm3c29 last message repeated 3 times
Apr 26 20:49:50 elm3c29 kernel: sd 0:0:1:0: [sda] Done: TIMEOUT
Apr 26 20:49:50 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:49:50 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Inquiry: 12 01 c9 00 30 00
Apr 26 20:50:00 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:50:31 elm3c29 last message repeated 2 times
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: TIMEOUT
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Read(10): 28 00 01 ac 41 38 00 00 08 00
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e 78 00 00 08 00
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e 00 00 00 78 00
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5d 00 00 00 08 00
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:31 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:32 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5d 20 00 00 08 00
Apr 26 20:50:33 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:34 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:35 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5d 38 00 00 08 00
Apr 26 20:50:35 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:35 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5d 78 00 00 08 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e 98 00 00 10 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e b0 00 00 30 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5d 90 00 00 08 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e e0 00 00 18 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e f8 00 00 18 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5f 10 00 00 08 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5f 38 00 00 08 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5e 90 00 00 08 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5f 18 00 00 20 00
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Done: TIMEOUT
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Write(10): 2a 00 00 92 5f 40 00 00 08 00
Apr 26 20:50:36 elm3c29 kernel: Error handler scsi_eh_0 waking up
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:4: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 16
Apr 26 20:50:36 elm3c29 kernel: sd 0:0:1:7: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 20:50:36 elm3c29 kernel: scsi 0:0:1:31: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
Apr 26 20:50:36 elm3c29 kernel: Total of 19 commands on 4 devices require eh work
Apr 26 20:50:36 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f1c09c0
Apr 26 20:50:36 elm3c29 kernel: qla2xxx_eh_abort(0): aborting sp ffff8100a59eff00 from RISC. pid=15796919.
Apr 26 20:50:45 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:50:55 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:51:01 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 20:51:01 elm3c29 kernel: qla2x00_mailbox_command(0): timeout calling abort_isp
Apr 26 20:51:01 elm3c29 kernel: qla2xxx 0000:03:05.0: Mailbox command timeout occured. Issuing ISP abort.
Apr 26 20:51:01 elm3c29 kernel: qla2xxx 0000:03:05.0: Performing ISP error recovery - ha= ffff81007ea44610.
Apr 26 20:51:01 elm3c29 kernel: scsi(0): **** Load RISC code ****
Apr 26 20:51:01 elm3c29 kernel: scsi(0): Verifying Checksum of loaded RISC code.
Apr 26 20:51:01 elm3c29 kernel: scsi(0): Checksum OK, start firmware.
Apr 26 20:51:01 elm3c29 kernel: scsi(0): Issue init firmware.
Apr 26 20:51:01 elm3c29 kernel: scsi(0): fcport-0 - port retry count: 29 remaining
Apr 26 20:51:01 elm3c29 kernel: scsi(0): fcport-1 - port retry count: 29 remaining
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Asynchronous P2P MODE received.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Asynchronous LOOP UP (4 Gbps).
Apr 26 20:51:02 elm3c29 kernel: qla2xxx 0000:03:05.0: LOOP UP detected (4 Gbps).
Apr 26 20:51:02 elm3c29 kernel: scsi(0): F/W Ready - OK 
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Port database changed ffff 0006 0000.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): fw_state=3 curr time=106830c8e.
Apr 26 20:51:02 elm3c29 kernel: qla2x00_restart_isp(): Start configure loop, status = 0
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0004/0600.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Asynchronous PORT UPDATE ignored 0000/0007/0b00.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): Configure loop -- dpc flags =0x4080048
Apr 26 20:51:02 elm3c29 kernel: scsi(0): RSCN queue entry[0] = [00/000000].
Apr 26 20:51:02 elm3c29 kernel: scsi(0): device_resync: rscn overflow.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): RFT_ID exiting normally.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): RFF_ID exiting normally.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): RNN_ID exiting normally.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): RSNN_NN exiting normally.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): GID_PT entry - nn 2000001b32052166 pn 2100001b32052166 portid=010400.
Apr 26 20:51:02 elm3c29 kernel: scsi(0): GID_PT entry - nn 2001000e1180034c pn 2001000e1180034c portid=011226.
Apr 26 20:51:02 elm3c29 java: SGIO Sense data: 0x00 
Apr 26 20:51:02 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 20:51:03 elm3c29 kernel: scsi(0): GID_PT entry - nn 200400a0b8421b14 pn 200400a0b8421b15 portid=011300.
Apr 26 20:51:05 elm3c29 java: SGIO host_status=0x8
Apr 26 20:51:08 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:51:10 elm3c29 multipathd: checker failed path 8:0 in map mpath0 
Apr 26 20:51:11 elm3c29 kernel: scsi(0): GPSC failed, rejected request:
Apr 26 20:51:11 elm3c29 java: SGIO driver_status=0x8
Apr 26 20:51:11 elm3c29 multipathd: mpath0: remaining active paths: 1 
Apr 26 20:51:11 elm3c29 kernel:  0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
Apr 26 20:51:11 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 20:51:11 elm3c29 kernel: --------------------------------------------------------------
Apr 26 20:51:11 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 20:51:11 elm3c29 kernel: 01  00  00  00  fa  01  00  00  80  01  00  00  00  01  00  00
Apr 26 20:51:11 elm3c29 kernel: scsi(0): GPSC command unsupported, disabling query...
Apr 26 20:51:11 elm3c29 kernel: qla24xx_fabric_logout(0): failed to complete IOCB -- completion status (31)  ioparam=a/0.
Apr 26 20:51:11 elm3c29 kernel: scsi(0): device wrap (011300)
Apr 26 20:51:11 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0081 for port 011226.
Apr 26 20:51:11 elm3c29 kernel: scsi(0): Trying Fabric Login w/loop id 0x0082 for port 011300.
Apr 26 20:51:11 elm3c29 kernel: scsi(0): LOOP READY
Apr 26 20:51:11 elm3c29 kernel: qla2x00_restart_isp(): Configure loop done, status = 0x0
Apr 26 20:51:11 elm3c29 kernel: qla2x00_abort_isp(0): exiting.
Apr 26 20:51:11 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 20:51:11 elm3c29 kernel: qla2x00_mailbox_command(0): finished abort_isp
Apr 26 20:51:11 elm3c29 kernel: qla2x00_mailbox_command(0): **** FAILED. mbx0=54, mbx1=0, mbx2=37bf, cmd=54 ****
Apr 26 20:51:11 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 20:51:11 elm3c29 kernel: qla2x00_issue_iocb(0): failed rval 0x100
Apr 26 20:51:11 elm3c29 kernel: qla24xx_abort_command(0): failed to issue IOCB (100).
Apr 26 20:51:11 elm3c29 kernel: qla2xxx_eh_abort(0): abort_command mbx failed.
Apr 26 20:51:11 elm3c29 kernel: qla2xxx 0000:03:05.0: scsi(0:1:31): Abort command issued -- 0 f10ab7 2002.
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f1c09c0 result: 2
Apr 26 20:51:11 elm3c29 kernel: scsi 0:0:1:31: Done: SUCCESS
Apr 26 20:51:11 elm3c29 kernel: scsi 0:0:1:31: Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:51:11 elm3c29 kernel: scsi 0:0:1:31: CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 20:51:11 elm3c29 kernel: scsi 0:0:1:31: Sense Key : Unit Attention [current] 
Apr 26 20:51:11 elm3c29 kernel: scsi 0:0:1:31: Add. Sense: Device internal reset
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f1c09c0, timeleft: 9997
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f1c09c0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f1e7940
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f1e7940 result: 2
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:0: [sda] Done: SUCCESS
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:0: [sda] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:0: [sda] Sense Key : Unit Attention [current] 
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:0: [sda] Add. Sense: Device internal reset
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f1e7940, timeleft: 9999
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f1e7940 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f0ff6c0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f0ff6c0 result: 2
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:7: [sdk] Done: SUCCESS
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:7: [sdk] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:7: [sdk] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:7: [sdk] Sense Key : Unit Attention [current] 
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:7: [sdk] Add. Sense: Device internal reset
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f0ff6c0, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f0ff6c0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f0ffa40
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f0ffa40 result: 2
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:4: [sde] Done: SUCCESS
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:4: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:4: [sde] CDB: Test Unit Ready: 00 00 00 00 00 00
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:4: [sde] Sense Key : Unit Attention [current] 
Apr 26 20:51:11 elm3c29 kernel: sd 0:0:1:4: [sde] Add. Sense: Device internal reset
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f0ffa40, timeleft: 9999
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f0ffa40 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81013c42c300
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81013c42c300 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81013c42c300, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81013c42c300 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810114f2a280
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff810114f2a280 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810114f2a280, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff810114f2a280 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff810114ec4d00
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff810114ec4d00 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff810114ec4d00, timeleft: 9998
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff810114ec4d00 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f1e7780
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f1e7780 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f1e7780, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f1e7780 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81013c42c140
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81013c42c140 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81013c42c140, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81013c42c140 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d91b340
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011d91b340 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d91b340, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d91b340 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d91bdc0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011d91bdc0 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d91bdc0, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d91bdc0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81013047f400
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81013047f400 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81013047f400, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81013047f400 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81010b329bc0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81010b329bc0 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81010b329bc0, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81010b329bc0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81009d041c00
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81009d041c00 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81009d041c00, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81009d041c00 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011d91ba40
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011d91ba40 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011d91ba40, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011d91ba40 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f0311c0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f0311c0 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f0311c0, timeleft: 9999
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f0311c0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81013047fcc0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81013047fcc0 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81013047fcc0, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81013047fcc0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81011f031a80
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81011f031a80 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81011f031a80, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81011f031a80 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: aborting cmd:0xffff81006f8d01c0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_done scmd: ffff81006f8d01c0 result: 0
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scmd: ffff81006f8d01c0, timeleft: 10000
Apr 26 20:51:11 elm3c29 kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_tur: scmd ffff81006f8d01c0 rtn 2002
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f1c09c0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f1e7940
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f0ff6c0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f0ffa40
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81013c42c300
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810114f2a280
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff810114ec4d00
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f1e7780
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81013c42c140
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d91b340
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d91bdc0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81013047f400
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81010b329bc0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81009d041c00
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011d91ba40
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f0311c0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81013047fcc0
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81011f031a80
Apr 26 20:51:11 elm3c29 kernel: scsi_eh_0: flush finish cmd: ffff81006f8d01c0
Apr 26 20:51:11 elm3c29 kernel: scsi_restart_operations: waking up host to restart
Apr 26 20:51:11 elm3c29 kernel: device-mapper: multipath: Failing path 8:0.
Apr 26 20:51:11 elm3c29 kernel: Error handler scsi_eh_0 sleeping
Apr 26 20:51:11 elm3c29 multipathd: sda: rdac checker reports path is down 
Apr 26 20:51:11 elm3c29 multipathd: 8:0: reinstated 
Apr 26 20:51:11 elm3c29 multipathd: mpath0: remaining active paths: 2 
Apr 26 20:51:11 elm3c29 multipathd: dm-0: add map (uevent) 
Apr 26 20:51:11 elm3c29 multipathd: dm-0: devmap already registered 
Apr 26 20:51:15 elm3c29 dhclient: DHCPREQUEST on eth2 to 9.47.69.50 port 67
Apr 26 20:51:52 elm3c29 last message repeated 3 times
Apr 26 20:53:04 elm3c29 last message repeated 4 times
Apr 26 20:54:11 elm3c29 last message repeated 5 times
Apr 26 20:55:14 elm3c29 last message repeated 4 times
Apr 26 20:56:18 elm3c29 last message repeated 5 times
Apr 26 20:57:20 elm3c29 last message repeated 4 times
Apr 26 20:58:24 elm3c29 last message repeated 4 times
Apr 26 20:59:31 elm3c29 last message repeated 4 times
Apr 26 21:00:34 elm3c29 last message repeated 5 times
Apr 26 21:01:41 elm3c29 last message repeated 5 times
Apr 26 21:02:49 elm3c29 last message repeated 5 times
Apr 26 21:04:02 elm3c29 last message repeated 5 times
Apr 26 21:05:16 elm3c29 last message repeated 5 times
Apr 26 21:06:29 elm3c29 last message repeated 5 times
Apr 26 21:07:39 elm3c29 last message repeated 5 times
Apr 26 21:08:46 elm3c29 last message repeated 4 times
Apr 26 21:09:50 elm3c29 last message repeated 4 times
Apr 26 21:11:02 elm3c29 last message repeated 5 times
Apr 26 21:12:13 elm3c29 last message repeated 4 times
Apr 26 21:13:14 elm3c29 last message repeated 4 times
Apr 26 21:14:33 elm3c29 last message repeated 5 times
Apr 26 21:15:38 elm3c29 last message repeated 4 times

--------------050107010703090202060009--

